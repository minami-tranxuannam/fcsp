class CompanyChatRoom < ApplicationRecord
  belongs_to :company
  belongs_to :user, class_name: User.name
  belongs_to :job, class_name: Job.name
  has_many :messages, class_name: CompanyChatMessage.name

  delegate :name, to: :company, prefix: true
  delegate :name, to: :user, prefix: true

  scope :search_by_candidate_name, ->key_word do
    left_outer_joins(:user)
    .where("LOWER(users.name) LIKE :name", name: "%#{key_word.downcase}%")
  end

  def mark_all_as_read
    messages.where(read: false).update_all read: true
  end

  def has_new_message?
    messages.where(read: false).size > 0
  end
end
