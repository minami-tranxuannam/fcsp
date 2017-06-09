class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.string :senderable_type
      t.integer :senderable_id
      t.string :receiverable_type
      t.integer :receiverable_id
      t.integer :chat_room_id

      t.timestamps
    end
  end
end
