class DropColumnFromUsersAvatarPath < ActiveRecord::Migration
  def change
    remove_column :users, :avatar_path
  end
end
