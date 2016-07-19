module ConversationBase

  def last_message
    self.messages.last ? self.messages.last.text : 'No messages yet'
  end

  def interlocutor?
    raise 'Abstract Method'
  end
end