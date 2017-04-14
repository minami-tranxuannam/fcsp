module Supports
  class Message
    attr_reader :rooms, :messages, :new_message, :search_room_result

    def initialize user, params
      @user = user
      @params = params
    end

    def user_rooms
      @user.company_chat_rooms
    end

    def messages
      CompanyChatRoom.find_by(id: @params[:chat_room_id]).messages if @params[:chat_room_id].present?
    end

    def new_message
      CompanyChatRoom.find_by(id: @params[:chat_room_id]).messages.build if @params[:chat_room_id].present?
    end

    def current_room
      CompanyChatRoom.find_by id: @params[:chat_room_id]
    end

    def company
      Company.find_by id: @params[:company_id]
    end

    def company_rooms
      company.company_chat_rooms
    end

    def search_room_result
      CompanyChatRoom.search_by_candidate_name @params[:candidate_name]
    end
  end
end
