class ConversationsController < BaseChatController

  def create
    @conversation = current_user.begin_conversation(params[:conversation][:recipient_id])
    redirect_to @conversation
  end

  def index
    @conversations = current_user.show_conversations
  end

  def show
    @conversation = Conversation.find_by(id: params[:id])
    @messages = @conversation.messages.order(created_at: :asc )
    read_unread_messages(@messages.unread_messages)
  end

  def destroy
    Conversation.find_by(id: params[:id]).destroy!
    super
  end

  private

  def interlocutor
    conversation = Conversation.find_by(id: params[:id])
    redirect_to current_user if conversation.nil? || !conversation.interlocutor?(current_user)
  end

end