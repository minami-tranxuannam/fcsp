class Employee < ApplicationRecord
  belongs_to :user
  belongs_to :company

  has_many :sent_mesages, as: :senderable, class_name: Message.name,
    dependent: :destroy
  has_many :received_messages, as: :receiverable, class_name: Message.name,
    dependent: :destroy
  has_many :chat_rooms, dependent: :destroy
end
