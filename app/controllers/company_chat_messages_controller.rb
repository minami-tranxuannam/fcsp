class CompanyChatMessagesController < ApplicationController
  before_action :mark_all_as_read, only: :new
  before_action :check_room_permission, only: [:new, :create]

  def new
    @messages_object = Supports::Message.new current_user, params
  end

  def create
    @company_chat_message = CompanyChatMessage.new company_chat_message_params
    @company_chat_message.attributes = {senderable: current_user, receiverable: Company.first}
    @company_chat_message.save!
    flash[:success] = "Success"
  end

  private

  def company_chat_message_params
    params.require(:company_chat_message).permit :company_chat_room_id,
      :content, :receiverable_id, :senderable_id
  end

  def mark_all_as_read
    room = CompanyChatRoom.find_by id: params[:chat_room_id]
    room.mark_all_as_read
  end

  def check_room_permission
    room = CompanyChatRoom.find_by id: params[:chat_room_id]
    redirect_to root_path unless room.present? && room.user == current_user
  end
end
