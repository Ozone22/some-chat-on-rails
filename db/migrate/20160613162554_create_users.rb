class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|

      t.string :email, :null => false
      t.string :login, :null => false
      t.boolean :is_online
      t.integer :unread_message_count

    end
  end
end
