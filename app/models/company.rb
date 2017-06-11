class Company < ApplicationRecord
  acts_as_followable
  has_many :jobs, dependent: :destroy
  has_many :candidates, through: :jobs
  has_many :candidate_users, through: :candidates, source: :user
  has_many :benefits, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :users, through: :employees
  has_many :company_industries, dependent: :destroy
  has_many :industries, through: :company_industries
  has_many :team_introductions, as: :team_target
  has_many :groups
  has_one :avatar, class_name: Image.name, foreign_key: :id,
    primary_key: :avatar_id
  has_one :cover_image, class_name: Image.name, foreign_key: :id,
    primary_key: :cover_image_id
  has_many :posts, as: :postable
  has_many :social_networks, as: :owner, dependent: :destroy
  has_many :chat_rooms, through: :employees

  after_create :create_organization

  ATTRIBUTES = [:name, :website, :introduction, :founder, :country,
    :company_size, :founder_on, addresses_attributes: [:id, :address,
    :longtitude, :latitude, :head_office], industry_ids: [],
    images_attributes: [:id, :imageable_id, :imageable_type,
      :picture, :caption]]

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  validates :name, presence: true,
    length: {maximum: Settings.company.max_length_name}
  validates :website, presence: true
  validates :company_size, numericality: {greater_than: 0}

  def create_organization
    org = Organization.find_or_create_by name: self.name
    org.update_attributes org_type: :real if org.present?
  end
end
