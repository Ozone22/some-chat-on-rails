class Message < ActiveRecord::Base

  belongs_to :dialog, polymorphic: true
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'

  delegate :show_avatar, to: :sender, prefix: true

  validates :text, :dialog_id, :dialog_type, :sender_id, presence: true
end