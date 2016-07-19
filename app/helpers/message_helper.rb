module MessageHelper

  def socket_message_publish(message)
    if message.dialog_type == 'Conversation'
      PrivatePub.publish_to(conversation_path(message.dialog), message)
    else
      PrivatePub.publish_to(room_path(message.dialog), message)
    end
  end
end