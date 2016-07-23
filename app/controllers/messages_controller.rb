class MessagesController < BaseMessageController

  def create
    super
    socket_message_publish(@message)
  end

  def destroy
    Message.find_by(id: params[:id]).destroy!
  end

end
