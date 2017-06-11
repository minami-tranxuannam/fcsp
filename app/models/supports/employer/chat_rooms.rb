module Supports::Employer
  class ChatRooms
    attr_reader :company, :employee

    def initialize user, chat_room
      @company = user.company
      @employee = user.employee
      @chat_room = chat_room
    end

    def company_chat_rooms
      @company.chat_rooms
    end

    def employee_chat_rooms
      @employee.chat_rooms
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
