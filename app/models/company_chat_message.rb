class CompanyChatMessage < ApplicationRecord
  belongs_to :company_chat_room
  belongs_to :senderable, polymorphic: true
  belongs_to :receiverable, polymorphic: true

  scope :unread_messages_count, ->user do
    where("receiverable_id = ? AND read = false", user.id).size
  end

  after_create_commit do
    NotificationBroadcastJob.perform_later self
  end
end
