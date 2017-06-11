jQuery(document).on 'ready', ->
  messages = $('.message-items')
  if $('.message-items').length > 0
    message_to_bottom = -> messages.scrollTop(messages.prop('scrollHeight'))

    message_to_bottom()

    App.global_chat = App.cable.subscriptions.create {
        channel: 'ChatRoomsChannel'
        chat_room_id: messages.data('chat-room-id')
      },
      connected: ->
        #
      disconnected: ->
        #
      received: (data) ->
        messages.append data['message']
        message_to_bottom()
      send_message: (message, chat_room_id) ->
        @perform 'send_message', message: message, chat_room_id: chat_room_id

    $('form#new_message').submit (e) ->
      textarea = $(this).find('#message_content')
      if $.trim(textarea.val()).length > 1
        App.global_chat.send_message textarea.val(), messages.data('chat-room-id')
        textarea.val('')
      e.preventDefault()
      return false
