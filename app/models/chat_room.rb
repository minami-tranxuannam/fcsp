class ChatRoom < ApplicationRecord
  belongs_to :company
  belongs_to :employee
  belongs_to :candidate

  has_many :messages, dependent: :destroy
end
