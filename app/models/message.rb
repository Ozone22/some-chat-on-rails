class Message < ActiveRecord::Base

  belongs_to :dialog, polymorphic: true
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'

  delegate :show_avatar, to: :sender, prefix: true

  validates :text, :dialog_id, :dialog_type, :sender_id, presence: true

  scope :unread_messages, -> do
    where(is_readed: false)
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