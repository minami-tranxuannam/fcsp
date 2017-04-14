FactoryGirl.define do
  factory :company_chat_message do
    company_chat_room nil
    content "MyText"
    sender_id 1
    receiver_id 1
  end
end
