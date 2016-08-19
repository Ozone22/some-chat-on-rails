class MessagesController < ApplicationController

  before_action :signed_in_user

  def create
    @message = Message.create!(message_params)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    Message.find_by(id: params[:id]).destroy!
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :text, :dialog_id, :dialog_type)
  end

end
