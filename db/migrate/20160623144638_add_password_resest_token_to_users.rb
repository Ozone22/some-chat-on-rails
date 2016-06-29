class AddPasswordResestTokenToUsers < ActiveRecord::Migration
  def up
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_send_at, :datetime
  end

  def down
    remove_column :users, :password_reset_token
    remove_column :users, :password_reset_send_at
  end
end
