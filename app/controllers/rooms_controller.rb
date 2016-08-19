class RoomsController < BaseChatController

  def create
    @room = current_user.begin_conference(params[:room])
    redirect_to @room
  end

  def show
    @room = Room.find_by(id: params[:id])
    @messages = @room.messages.order(created_at: :asc)
    read_unread_messages(@messages.unread_messages)
  end

  def destroy
    Room.find_by(id: params[:id]).destroy!
    super
  end

  private

  def interlocutor
    room = Room.find_by(id: params[:id])
    redirect_to current_user if room.nil? || !room.interlocutor?(current_user)
  end

end
