class CreateCompanyChatMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :company_chat_messages do |t|
      t.references :company_chat_room, foreign_key: true
      t.text :content
      t.integer :senderable_id
      t.string :senderable_type
      t.integer :receiverable_id
      t.string :receiverable_type
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
