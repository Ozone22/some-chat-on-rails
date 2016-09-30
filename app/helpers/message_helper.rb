module MessageHelper

  def socket_message_route(message)
    if message.dialog_type == 'Conversation'
      conversation_path(message.dialog)
    else
      room_path(message.dialog)
    end
  end

  # def fetch_messages(conversation_id, conversation_type, message_collection)
  #   key = "#{ conversation_type }#{conversation_id}"
  #   messages = REDIS.get(key)
  #   if messages.nil?
  #     messages = get_messages_by_params(message_collection)
  #     REDIS.set(key, messages.map { |message| message.to_json } )
  #   end
  #   @messages = JSON.parse(messages).map { |json_message| Message.new.from_json(json_message) }
  # end

  def unread_message_class(unread_messages)
    if unread_messages_exist?(unread_messages)
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

  def js_message_text(text)
    text.to_json
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