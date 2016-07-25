module MessageHelper

  def socket_message_route(message)
    if message.dialog_type == 'Conversation'
      conversation_path(message.dialog)
    else
      room_path(message.dialog)
    end
  end

  def message_time(datetime)
    local_time = datetime.localtime
    if local_time < DateTime.now.to_date
      local_time.strftime("%d.%m.%Y")
    else
      local_time.strftime("%H:%M:%S")
    end
  end

end