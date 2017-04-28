class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    @message = message
    if message.senderable.class.name == Company.name
      hr_group = message.senderable.groups.find_by name: "HR"
      hr_group.users.each do |user|
        ActionCable.server.broadcast "notifications_#{user.id}_channel",
          message: message, company_chat_room_id: message.company_chat_room_id,
          senderable: message.senderable
      end
      ActionCable.server.broadcast "notifications_#{message.receiverable_id}_channel",
       message: message,
       company_chat_room_id: message.company_chat_room_id,
       company: message.senderable,
       job: message.company_chat_room.job,
       senderable: message.senderable,
       unread_messages_count: CompanyChatMessage.unread_messages_count(message.receiverable)
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

  def broadcast_to_users user_ids
    user_ids.each do |id|
      ActionCable.server.broadcast "notifications_#{id}_channel",
       message: @message,
       company_chat_room_id: @message.company_chat_room_id,
       company: @message.senderable,
       job: @message.company_chat_room.job,
       senderable: @message.senderable,
       unread_messages_count: CompanyChatMessage.unread_messages_count(@message.receiverable)
    end
  end
end
