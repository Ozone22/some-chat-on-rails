class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|

      t.integer :friend_id, null: false
      t.integer :user_id, null: false
      t.integer :status, default: 0

    end

    add_index :relationships, :friend_id
    add_index :relationships, :user_id
    add_index :relationships, [:friend_id, :user_id], unique: true

  end
end
