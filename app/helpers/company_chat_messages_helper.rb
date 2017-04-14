module CompanyChatMessagesHelper
  def load_senderable_avatar senderable, options = {}
    if senderable.class.name == Company.name
      image_tag "avatar.jpg", alt: senderable.name.to_s,
        class: options[:class].to_s, size: options[:size].to_s
    else
      load_user_avatar senderable, options
    end
  end
end
