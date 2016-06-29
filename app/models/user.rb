class User < ActiveRecord::Base

  before_save { self.email.downcase! }
  before_create  :create_remember_token, :create_confirm_token
  before_destroy :remove_avatar

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  #Pass contain at least 1 digit and 1 Capital Character
  VALID_PASS_REGEX = /(?=^.{5,}\z)(?=.*[A-Z])(?=.*\d).*\z/

  validates :login, presence: true, length: { minimum: 3, maximum: 60 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, maximum: 60 }, format: { with: VALID_PASS_REGEX }

  # Validates for user avatars
  has_attached_file :avatar, styles: { original: "220x220#", thumb: "90x90#" },
                    storage: :dropbox,
                    dropbox_credentials: { app_key: ENV['APP_KEY'],
                                              app_secret: ENV['APP_SECRET'],
                                              access_token: ENV['ACCESS_TOKEN'],
                                              access_token_secret: ENV['ACCESS_TOKEN_SECRET'],
                                              user_id: ENV['USER_ID'],
                                              access_type: 'app_folder'},
                    default_url: ENV['DEFAULT_AVATAR_PATH'],
                    path: "public/system/#{ Rails.env }/:attachment/:id/:hash.:extension",
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

  def send_password_reset
    # We update just few fields
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
    if self.avatar.exists? && self.avatar != ENV['DEFAULT_AVATAR_PATH']
      self.avatar.clear
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

end
