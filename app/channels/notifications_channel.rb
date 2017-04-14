class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from("notifications_#{current_user.id}_channel")
  end

  def unsubscribed
  end

  def send_message(data)
    if data["company_id"].present?
      company = Company.find_by id: data["company_id"]
      employee = User.find_by id: 1
      company_chat_message = company.sent_company_chat_messages
        .build content: data["content"], receiverable: employee,
        company_chat_room_id: data["company_chat_room_id"]
    else
      company_chat_message = current_user.sent_company_chat_messages
        .build content: data["content"], receiverable: Company.first,
        company_chat_room_id: data["company_chat_room_id"]
    end
    company_chat_message.save!
  end
end
