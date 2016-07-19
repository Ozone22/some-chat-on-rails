class CreateRoomUsers < ActiveRecord::Migration
  def change
    create_table :room_users do |t|
      t.integer :room_id, null: false
      t.integer :user_id, null: false
    end

    add_index :room_users, :room_id
    add_index :room_users, :user_id
    add_index :room_users, [:room_id, :user_id], unique: true
  end
end
