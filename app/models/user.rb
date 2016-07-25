class User < ActiveRecord::Base

  has_many :relationships, dependent: :destroy
  has_many :inverted_relationships, foreign_key: 'friend_id', class_name: 'Relationship', dependent: :destroy
  has_many :friends, -> { where(relationships: { status: Relationship.statuses[:accepted] } )},
           through: :relationships
  has_many :requested_friends, -> { where(relationships: { status: Relationship.statuses[:requested] } )},
           source: :friend, through: :relationships
  has_many :pending_friends, -> { where(relationships: { status: Relationship.statuses[:pending] } )},
           source: :friend, through: :relationships
  has_many :conversations, foreign_key: 'sender_id', dependent: :destroy
  has_many :messages, foreign_key: 'sender_id', dependent: :destroy
  has_many :room_relations, class_name: 'RoomUser', dependent: :destroy
  has_many :rooms, through: :room_relations

  before_save { self.email.downcase! }
  before_create  :create_remember_token, :create_confirm_token
  before_destroy :remove_avatar

  validates :login, presence: true, length: { minimum: 3, maximum: 60 }
  validates :email, presence: true, email: true,
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, maximum: 60 }, password: true

  # Validates for user avatars
  has_attached_file :avatar, styles: { original: "220x220#", thumb: "90x90#" },
                    storage: :cloudinary,
                    cloudinary_upload_options: {
                      public_id: 'avatar',
                      styles: {
                          thumb: {
                              transformation: [
                                  { :crop => 'thumb', :gravity => 'face' }
                              ]
                          }
                      }
                    },
                    default_url: ENV['DEFAULT_AVATAR_PATH'],
                    path: "#{ Rails.env }/:attachment/:id/:hash.:extension",
                    hash_secret: Rails.application.secrets.secret_key_base,
                    size: { in: 0..500.kilobytes }

  validates_attachment_content_type :avatar, content_type: /^image\/(png|gif|jpeg)/

  has_secure_password

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # We update just few fields(without pass)
  def send_password_reset
    self.password_reset_token = User.encrypt(User.new_token)
    self.password_reset_send_at = Time.zone.now
    self.save!(validate: false)
    UserMailer.password_reset(self).deliver_now
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def remove_avatar
    self.avatar.clear unless
      self.avatar.eql?(ENV['DEFAULT_AVATAR_PATH'])
  end

  def show_avatar(args)
    if self.avatar.url.blank?
      default_avatar_path(args)
    else
      self.avatar.url(args, cloudinary: { secure: true })
    end
  end

  def begin_conversation(recipient_id)
    if Conversation.between(self.id, recipient_id).present?
      Conversation.between(self.id, recipient_id).first
    else
      conversations.create!(recipient_id: recipient_id)
    end
  end

  def begin_conference(params)
    transaction do
      room = params[:name].nil? ? rooms.create! : rooms.create!(name: params[:name])
      params[:users].each { |user| room.add_interlocutor(user) } if params[:users].present?
      room
    end
  end

  def show_conversations
    (Conversation.involving(self.id) << Room.involving(self.id)).flatten!
  end

  def friend?(friend)
    relationships.exists?(friend_id: friend.id)
  end

  def friends_with!(friend)
    unless self == friend || relationships.exists?(friend_id: friend.id)
      transaction do
        relationships.create!(friend: friend, status: :pending)
        inverted_relationships.create!(user: friend, status: :requested)
      end
    end
  end

  def accept_friendship(friend)
    transaction do
      one_side = relationships.find_by(friend_id: friend.id)
      one_side.update_attribute(:status, :accepted)
      second_side = inverted_relationships.find_by(user_id: friend.id)
      second_side.update_attribute(:status, :accepted)
    end
  end

  def breakup_with!(friend)
    transaction do
      relationships.find_by(friend_id: friend.id).destroy!
      inverted_relationships.find_by(user_id: friend.id).destroy!
    end
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_token)
  end

  def create_confirm_token
    if self.confirm_token.blank?
      self.confirm_token = User.encrypt(User.new_token)
    end
  end

  def default_avatar_path(args)
    "/images/#{args}/default.png"
  end

end
