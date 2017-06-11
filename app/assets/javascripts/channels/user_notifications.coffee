jQuery(document).on 'ready', ->
  badge = $('.user-notifications-badge')
  if $('.user-notifications-badge').length > 0
    App.global_notification = App.cable.subscriptions.create {
        channel: 'UserNotificationsChannel'
      },
      connected: ->
        #
      disconnected: ->
        #
      received: (data) ->
        badge.html data.unread_chat_rooms.length
        render_unread_chat_rooms(data.unread_chat_rooms, $('ul.user-notifications'))
        if $('li.room-item[data-chat-room-id=' + data.chat_room_id + ']').length > 0
          $('li.room-item[data-chat-room-id=' + data.chat_room_id + ']').addClass 'has-unread-message'

render_unread_chat_rooms = (rooms, element) ->
  element.empty()
  element.append(room) for room in rooms
