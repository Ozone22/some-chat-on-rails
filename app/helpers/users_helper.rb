module UsersHelper

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

end