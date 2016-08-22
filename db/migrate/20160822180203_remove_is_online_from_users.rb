class RemoveIsOnlineFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_online
  end
end
