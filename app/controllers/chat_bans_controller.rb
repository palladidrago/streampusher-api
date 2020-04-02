class ChatBansController < ApplicationController
  def index
    authorize! :admin, :chats
    @connections = Chat.all_connections
    @bans = Chat.bans
  end

  def create
    authorize! :admin, :chats
    Chat.ban chat_ban_params[:socket_id]
    flash[:notice] = "Banned!"
    render 'create'
  end

  def destroy
    authorize! :admin, :chats
    ip_address = chat_ban_params[:ip_address]
    Chat.unban ip_address
    flash[:notice] = "Unbanned!"
    render 'create'
  end

  private
  def chat_ban_params
    params.require(:chat_ban).permit(:socket_id, :ip_address)
  end
end
