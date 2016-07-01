class ResetPasswordController < ApplicationController

  def new
  end

  def create
    if params[:email] && email_valid(params[:email])
      @user = User.find_by_email(params[:email].downcase)
      if @user
        @user.send_password_reset
        flash[:info] = 'Email send with instructions'
        redirect_to root_path
      else
        flash.now[:danger] = 'User with some email not found'
        render 'new'
      end
    else
      flash.now[:danger] = 'Email invalid'
      render 'new'
    end
  end

  def new_pass
    @user = User.find_by_password_reset_token(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token(params[:id])
    if @user.password_reset_send_at < 2.hours.ago
      flash[:warning] = 'Reset has expired. Please resend email'
      redirect_to new_reset_password_path
    elsif @user.update_attributes(user_params)
      flash[:success] = 'Password changed'
      redirect_to signin_path
    else
      render 'new_pass'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end