class Relationship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  enum status: [:requested, :accepted, :pending]

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true

end
