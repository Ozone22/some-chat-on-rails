module MessageHelper

  def socket_message_route(message)
    if message.dialog_type == 'Conversation'
      conversation_path(message.dialog)
    else
      room_path(message.dialog)
    end
  end

  def unread_message_class(unread_messages)
    css_class = if unread_messages_exist?(unread_messages)
                  'unread_message'
                end
  end

  def read_unread_messages(unread_messages)
    if unread_messages_exist?(unread_messages)
      unread_messages.read_all
    end
  end

  def unread_messages_exist?(unread_messages)
    unread_messages.present? && unread_messages.last.sender != current_user
  end

  def unread_message_count
    conversation_messages = Message.conversation_unread_messages_by(current_user.id)
    room_messages = Message.room_unread_messages_by(current_user.id)
    conversation_messages.length + room_messages.length
  end

  def get_messages_by_params(messages)
    if params[:m]
      messages.order(created_at: :asc)
    elsif params[:search].present?
      messages.search(params[:search]).order(created_at: :asc )
    else
      messages.order(created_at: :asc ).last(10)
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