class MessagesController < BaseMessageController

  def create
    super
    socket_message_publish(@message)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    Message.find_by(id: params[:id]).destroy!
  end

end
