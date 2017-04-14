class CreateCompanyChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :company_chat_rooms do |t|
      t.references :company, foreign_key: true
      t.references :user, foreign_key: true
      t.references :job, foreign_key: true

      t.timestamps
    end
    add_index :company_chat_rooms, [:company_id, :user_id, :job_id], unique: true
  end
end
