class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      if user.email_confirmed
        sign_in user
        redirect_back_or user
      else
        flash.now[:warning] = 'Please activate your account first'
        render 'new'
      end
    else
      flash.now[:danger] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
