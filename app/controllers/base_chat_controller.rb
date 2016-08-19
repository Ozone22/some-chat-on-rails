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

  def html_parse
    @data = HtmlParser.parse(params[:url]).to_json
    @message = Message.find_by(id: params[:id]) if params[:id].present?
    respond_to do |format|
      format.js
      format.json { render json: @data }
    end
  end

  protected

  def interlocutor
    raise 'Abstract Method'
  end

end