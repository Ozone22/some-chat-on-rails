module ResetPasswordHelper

  def email_valid(email)
    regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    email =~ regex
  end
end
