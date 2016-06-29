class UserMailer < ApplicationMailer

  default from: 'adidasruslan@gmail.com'

  def password_reset(user)
    @password_reset_url = new_pass_url(user.password_reset_token)
    mail(to: user.email, subject: 'Password reset on Some_Chat')
  end

  def email_confirmation(user)
    @login = user.login
    @confirmation_url = confirm_email_user_url(user.confirm_token)
    mail(to: user.email, subject: 'Email confirmation')
  end
end
