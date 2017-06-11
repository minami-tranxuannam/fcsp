FactoryGirl.define do
  factory :message do
    content "MyString"
    senderable_type "MyString"
    senderable_id 1
    receiverable_type "MyString"
    receiverable_id 1
  end
end
