class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_follower
  has_friendship
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :articles
  has_many :education_posts, class_name: Education::Post.name
  has_many :education_socials, class_name: Education::Social.name
  has_many :education_comments, class_name: Education::Comment.name
  has_many :education_rates, class_name: Education::Rate.name
  has_many :education_project_members, class_name: Education::ProjectMember.name
  has_many :course_members, class_name: Education::CourseMember.name
  has_many :education_courses, through: :course_members, source: :course
  has_many :education_projects, through: :education_project_members,
    source: :project
  has_many :education_user_groups, class_name: Education::UserGroup.name
  has_many :education_groups, class_name: Education::Group.name,
    through: :education_user_groups, source: :group
  has_one :education_program_member, class_name: Education::ProgramMember.name
  has_one :education_learning_program, through: :education_program_member
  has_many :user_groups, dependent: :destroy
  has_many :employer_groups, class_name: Group.name, through: :user_groups,
    source: :group
  has_many :images, as: :imageable, dependent: :destroy
  has_many :education_images, class_name: Education::Image.name,
    as: :imageable, dependent: :destroy
  has_many :candidates, dependent: :destroy
  has_many :jobs, through: :candidates
  has_many :bookmarks, dependent: :destroy
  has_one :info_user
  has_many :skill_users, dependent: :destroy
  has_many :skills, through: :skill_users
  has_many :user_portfolios, dependent: :destroy
  has_many :user_educations, dependent: :destroy

  delegate :introduce, to: :info_user, prefix: true

  mount_uploader :avatar, AvatarUploader
  enum role: [:user, :admin]
  enum education_status: [:blocked, :active], _prefix: true

  after_create :create_user_group

  validates :name, presence: true,
    length: {maximum: Settings.user.max_length_name}
  validates :email, presence: true
  validates :education_status, presence: true

  scope :not_in_object, ->object do
    where("id NOT IN (?)", object.users.pluck(:user_id)) if object.users.any?
  end

  scope :in_object, ->object do
    where("id IN (?)", object.users.pluck(:user_id))
  end

  scope :of_education, -> do
    joins(:education_user_groups).distinct
  end

  class << self
    def import file
      (2..spreadsheet(file).last_row).each do |row|
        value = Hash[[header_of_file(file),
          spreadsheet(file).row(row)].transpose]
        user = find_by(id: value["id"]) || new
        user.attributes = value.to_hash.slice *value.to_hash.keys
        unless user.save
          raise "#{I18n.t('education.import_user.row_error')} #{row}: \
            #{user.errors.full_messages}"
        end
      end
    end

    def open_spreadsheet file
      case File.extname file.original_filename
      when ".csv" then Roo::CSV.new file.path
      when ".xls" then Roo::Excel.new file.path
      when ".xlsx" then Roo::Excelx.new file.path
      else raise "#{I18n.t('education.import_user.unknow_format')}: \
        #{file.original_filename}"
      end
    end

    def spreadsheet file
      open_spreadsheet file
    end

    def header_of_file file
      spreadsheet(file).row 1
    end
  end

  def bookmark job
    bookmarks.create job_id: job.id
  end

  def unbookmark job
    bookmarks.find_by(job_id: job.id).destroy
  end

  def apply_job job
    candidates.create job_id: job.id
  end

  def unapply_job job
    candidates.find_by(job_id: job.id).destroy if job.present?
  end

  private

  def create_user_group
    self.user_groups.create
  end
end
