class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :friends]
  before_action :correct_user, only: [:edit, :update, :friends]
  before_action :admin_user, only: [:destroy]
  before_action :redirect_current_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    @friends = @user.friends.limit(4)
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

  # Before update, we delete old avatar from server
  def update
    @user = User.find_by(id: params[:id])

    @user.remove_avatar unless params[:avatar].blank?

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

  def friends
    @users = user_friends_by_status(params[:status] || 'accepted')
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

  def user_friends_by_status(status)
    user_list = User.find_by(id: params[:id])
    if status == 'requested'
      user_list.requested_friends.all
    elsif status == 'pending'
      user_list.pending_friends.all
    else
      user_list.friends.all
    end
  end

  # Before filter

  def admin_user
    redirect_to current_user unless current_user.admin?
  end

end
