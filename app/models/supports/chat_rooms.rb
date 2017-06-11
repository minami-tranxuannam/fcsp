module Supports
  class ChatRooms
    attr_reader :chat_room, :candidate

    def initialize user, chat_room
      @chat_room = chat_room
      @candidate = chat_room.candidate
      @user = user
    end

    def candidate_chat_rooms
      @user.chat_rooms
    end

    def messages
      @chat_room.messages
    end

    def last_message
      @chat_room.messages.last
    end

    def new_message
      Message.new
    end
  end
end
