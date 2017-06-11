class ChatRoomsController < ApplicationController
  before_action :load_chat_room, only: [:show]

  def index
    redirect_to ChatRoom.first
  end

  def show
    @chat_rooms_support = Supports::ChatRooms.new current_user, @chat_room
    @chat_room.mark_read @chat_room.candidate
  end

  private

  def load_chat_room
    @chat_room = ChatRoom.find_by id: params[:id],
      candidate: Candidate.find_by(user: current_user)
  end
end
