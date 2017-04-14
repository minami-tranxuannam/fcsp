class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform company_chat_message
    message = render_message company_chat_message
    if company_chat_message.senderable.class.name == Company.name
      hr_group = company_chat_message.senderable.groups.find_by name: "HR"
      hr_group.users.each do |user|
        ActionCable.server.broadcast "notifications_#{user.id}_channel",
          message: message, company_chat_room_id: company_chat_message.company_chat_room_id
      end
      ActionCable.server.broadcast "notifications_#{company_chat_message.receiverable_id}_channel",
       notification: render_notification(company_chat_message), message: message,
       company_chat_room: render_room(company_chat_message),
       company_chat_room_id: company_chat_message.company_chat_room_id,
       company: company_chat_message.senderable.id,
       unread_messages_count: CompanyChatMessage.unread_messages_count(company_chat_message.receiverable)
    else
      ActionCable.server.broadcast "notifications_#{company_chat_message.senderable.id}_channel",
        message: message, company_chat_room_id: company_chat_message.company_chat_room_id
      hr_group = company_chat_message.receiverable.groups.find_by name: "HR"
      hr_group.users.each do |user|
        ActionCable.server.broadcast "notifications_#{user.id}_channel",
          notification: render_notification(company_chat_message),
          message: message, company_chat_room_id: company_chat_message.company_chat_room_id
      end
    end
  end

  private

  def render_notification message

  end

  def render_message message
    # binding.pry
    # content_tag :li, class: "user-message-item" do
    #   content_tag :div, class: "user-message-sender" do
    #     content_tag :div, class: "user-message-sender-avatar" do
    #       load_user_avatar current_user, class: "img-circle img-h-50"
    #     end
    #     content_tag :div, class: "user-message-info-wrapper" do
    #       content_tag :div, class: "user-message-sender-info" do
    #         content_tag :div, class: "user-message-sender-name" do
    #           link_to company_chat_message.senderable.name,
    #             user_path(company_chat_message.senderable)
    #         end
    #         content_tag :div, class: "user-message-sender-date" do
    #           I18n.localize company_chat_message.created_at,
    #             format: "%m-%y-%y"
    #         end
    #       end
    #       content_tag :div, class: "user-message-sender-company-name" do
    #         "Framgia"
    #       end
    #     end
    #   end
    #   content_tag :p, class: "user-message-item-content" do
    #     company_chat_message.content
    #   end
    # end
    # binding.pry
    ApplicationController.renderer.render message
  end

  def render_room message
    CompanyChatMessagesController.render partial: "company_chat_room",
      locals: {room: message.company_chat_room}
  end
end
