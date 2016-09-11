class RelationshipsController < ApplicationController

  before_action :signed_in_user

  def create
    user = User.find_by(id: params[:relationship][:friend_id])
    current_user.friends_with!(user)
    flash[:success] = 'Request for friendship sended'
    redirect_to :back
  end

  def destroy
    user = Relationship.find_by(id: params[:id]).friend
    current_user.breakup_with(user)
    flash[:success] = 'User removed from friends'
    redirect_to :back
  end

  def update
    user = Relationship.find_by(id: params[:id]).friend
    current_user.accept_friendship(user)
    flash[:success] = 'Friendship accepted'
    redirect_to :back
  end

end
