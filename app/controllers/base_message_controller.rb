class BaseMessageController < ApplicationController

  before_action :signed_in_user

  protected

  def create
    @message = Message.create!(message_params)
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :text, :dialog_id, :dialog_type)
  end

end