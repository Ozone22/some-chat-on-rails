class Message < ActiveRecord::Base

  belongs_to :dialog, polymorphic: true
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'

  delegate :show_avatar, to: :sender, prefix: true

  validates :text, :dialog_id, :dialog_type, :sender_id, presence: true

  scope :unread_messages, -> do
    where(is_readed: false)
  end

  scope :conversation_unread_messages_by, -> (recipient_id) do
    where(dialog_type: 'Conversation').
      joins('INNER JOIN conversations ON messages.dialog_id = conversations.id').
        where.not(sender_id: recipient_id).
          where('is_readed = false AND (conversations.sender_id=? OR recipient_id=?)', recipient_id, recipient_id)
  end

  scope :room_unread_messages_by, -> (recipient_id) do
    where(dialog_type: 'Room').
      joins('INNER JOIN room_users ON messages.dialog_id = room_users.room_id').
        where.not(sender_id: recipient_id).
          where(is_readed: false, room_users: { user_id: recipient_id })
  end

  scope :read_all, -> do
    update_all(is_readed: true)
  end

  scope :search, -> (search) do
    if search
      where("text LIKE ?", "%#{search}%")
    else
      all
    end
  end

end