module MessageHelper

  def socket_message_route(message)
    if message.dialog_type == 'Conversation'
      conversation_path(message.dialog)
    else
      room_path(message.dialog)
    end
  end
end