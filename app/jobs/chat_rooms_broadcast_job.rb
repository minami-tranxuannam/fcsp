class ChatRoomsBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast "chat_rooms_#{message.chat_room_id}_channel",
      message: render_message(message)
    ActionCable.server.broadcast "user_notifications_#{message.receiverable.user_id}_channel",
      unread_chat_rooms: render_unread_chat_rooms, chat_room_id: message.chat_room_id
  end

  private

  def render_message message
    MessagesController.render partial: 'messages/message',
      locals: {message: message}
  end

  def render_unread_chat_rooms
    ChatRoom.unread.map do |chat_room|
      ChatRoomsController.render partial: 'chat_rooms/unread_chat_room',
        locals: {chat_room: chat_room}
    end
  end
end
