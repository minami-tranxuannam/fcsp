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
    mock_env = Rack::MockRequest.env_for('/')
    catch("env") do
      Rails.application.middleware.build(->(env) {
        throw "env", env
      }).call mock_env
    end
    warden = mock_env["warden"]
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, {"HTTP_HOST"=>"localhost:3000",
      "HTTPS"=>"off",
      "REQUEST_METHOD"=>"GET",
      "SCRIPT_NAME"=>"",
      "warden" => warden})
    renderer.render message
  end

  def render_room message
    CompanyChatMessagesController.render partial: "company_chat_room",
      locals: {room: message.company_chat_room}
  end
end
