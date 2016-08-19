class Room < ActiveRecord::Base

  include ConversationBase

  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  has_many :messages, as: :dialog

  delegate :unread_messages, to: :messages

  scope :involving, ->(user_id) do
    joins(:room_users).where("user_id = ?", user_id)
  end

  def interlocutor?(user)
    users.exists?(user.id)
  end

  def add_interlocutor(user_id)
    user = User.find_by(id: user_id)
    users << user unless user.nil? || interlocutor?(user)
  end

end
