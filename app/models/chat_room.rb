class ChatRoom < ApplicationRecord
  belongs_to :employee
  belongs_to :candidate

  has_many :messages, dependent: :destroy
  delegate :name, to: :employee, prefix: true

  scope :unread, -> do
    joins(:messages)
      .where("messages.read = false")
      .group(:id)
  end

  def read?
    messages.where({read: false}).empty?
  end

  def mark_read receiverable
    messages.where({receiverable: receiverable, read: false}).each do |message|
      message.update_attributes read: true
    end
  end
end
