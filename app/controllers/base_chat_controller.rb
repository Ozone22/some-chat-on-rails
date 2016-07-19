class BaseChatController < ApplicationController

  before_action :signed_in_user
  before_action :interlocutor, only: [:show]

  def show
    raise 'Abstract Method'
  end

  def destroy
    flash[:success] = 'Successfully deleted'
    redirect_to conversations_path
  end

  protected

  def interlocutor
    raise 'Abstract Method'
  end

end