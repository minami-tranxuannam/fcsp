class Message < ApplicationRecord
  belongs_to :senderable, polymorphic: true
  belongs_to :receiverable, polymorphic: true
  belongs_to :chat_room
end
