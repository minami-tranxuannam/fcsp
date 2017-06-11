class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms do |t|
      t.references :employee, foreign_key: true
      t.references :candidate, foreign_key: true
      t.timestamps
    end
  end
end
