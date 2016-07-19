class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, null: false, default: 'some-room', limit: 50
    end
  end
end
