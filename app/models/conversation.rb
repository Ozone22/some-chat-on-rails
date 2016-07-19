class Conversation < ActiveRecord::Base

  include ConversationBase

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  has_many :messages, as: :dialog

  validates :sender_id, presence: true,
            uniqueness: { scope: :recipient_id }
  validates :recipient_id, presence: true
  validate :conversation_unique

  scope :between, -> (recipient_id, sender_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)",
          sender_id,recipient_id, recipient_id, sender_id)
  end

  scope :involving, -> (user_id) do
    where("conversations.sender_id = ? OR conversations.recipient_id = ?", user_id, user_id)
  end

  def interlocutor?(user)
    user == self.recipient || user == self.sender
  end

  private

  def conversation_unique
    if self.recipient && self.sender
      errors.add(:base, 'They are not unique') if Conversation.between(self.recipient.id, self.sender.id).present?
    end
  end
end