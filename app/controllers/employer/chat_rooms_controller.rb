class Employer::ChatRoomsController < Employer::BaseController
  def index
  end

  def show
    @chat_rooms = ChatRoom.all
    @chat_room = ChatRoom.first
    @messages = @chat_room.messages
    @message = Message.new
  end
end
