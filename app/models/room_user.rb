class RoomUser < ActiveRecord::Base

  belongs_to :room
  belongs_to :user, foreign_key: 'user_id'

  validates :room_id, presence: true
  validates :user_id, presence: true,
            uniqueness: { scope: :room_id }

end
