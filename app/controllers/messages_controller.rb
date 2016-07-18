class MessagesController < BaseMessageController

  def create
    super
    PrivatePub.publish_to(conversation_path(@message.dialog), @message)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

end
