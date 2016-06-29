class AddDefaultValuesToUser < ActiveRecord::Migration
  def change
    change_column :users, :unread_message_count, :integer, :default => 0
    change_column :users, :is_online, :boolean, :default => true
  end
end
