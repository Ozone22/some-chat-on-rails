class UsersController < ApplicationController

  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Almost Done! Please confirm your email'
      UserMailer.email_confirmation(@user).deliver_later
      redirect_to signin_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    # remove the old avatar file from server
    unless params[:avatar].blank?
      @user.remove_avatar
    end

    if @user.update_attributes(user_params)
      flash[:success] = 'Profile successfully updated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def confirm_email
    @user = User.find_by_confirm_token(params[:id])
    if @user
      @user.email_activate
      flash[:success] = 'Email confirmed! Now you can sign in'
      redirect_to signin_path
    else
      flash[:danger] = 'Sorry, user does not exist'
      redirect_to root_path
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = 'User destroyed'
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation, :avatar)
  end

  #Before filter

  def signed_in_user
    unless signed_in?
      flash[:warning] = 'Please sign in first'
      store_location
      redirect_to signin_url
    end
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    unless current_user?(@user)
      flash[:warning] = 'Access denied'
      redirect_to current_user
    end
  end

end
