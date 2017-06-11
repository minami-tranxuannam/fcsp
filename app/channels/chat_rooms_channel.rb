class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_rooms_#{params[:chat_room_id]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message data
    chat_room = ChatRoom.find_by id: data["chat_room_id"]
    senderable = chat_room.candidate.user == current_user ? chat_room.candidate : chat_room.employee
    receiverable = chat_room.candidate.user == current_user ? chat_room.employee : chat_room.candidate
    chat_room.messages.create senderable: senderable,
      receiverable: receiverable, content: data["message"]
  end
end
