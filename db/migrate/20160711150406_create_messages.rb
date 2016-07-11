class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text, null: false
      t.boolean :is_readed, default: false
      t.references :dialog, polymorphic: true, index: true
      t.datetime :created_at
    end
  end
end
