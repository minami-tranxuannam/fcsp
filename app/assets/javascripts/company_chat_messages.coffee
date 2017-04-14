jQuery(document).on 'ready', ->
  messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))
  messages = $('.user-message-items')
  notification = $('a.message-notification')
  badge = $(notification).find('.badge')
  App.company_chat = App.cable.subscriptions.create {
    channel: "NotificationsChannel"
  },
  send_message: (content, company_chat_room_id, company_id) ->
    @perform 'send_message', content: content, company_chat_room_id: company_chat_room_id, company_id: company_id

  connected: ->

  disconnected: ->

  received: (data) ->
    console.log data
    if messages.length > 0
      messages.append(data['message'])
      messages_to_bottom()
      chat_room = $('li#'+data['company_chat_room_id'])
      $(chat_room).replaceWith data['company_chat_room']
      url = $(location).attr('href')
      if url.indexOf('chat_room_id=' + data['company_chat_room_id']) > -1
        setTimeout (->
          $('.user-message-info-new').removeClass 'user-message-info-new'
        ), 2000
    else
      $(badge).html data['unread_messages_count']
      $(notification).prop 'href', '/company_chat_messages/new?chat_room_id=' + data['company_chat_room_id']

  if messages.length > 0
    messages_to_bottom()
    $('#new_company_chat_message').submit (e)->
      $this = $(this)
      textarea = $this.find('#company_chat_message_content')
      company = $this.find('#company_chat_message_senderable_id')
      if $.trim(textarea.val()).length > 1
        App.company_chat.send_message textarea.val(), $this.find('#company_chat_message_company_chat_room_id').val(), company.val()
        textarea.val('')
      e.preventDefault()
      return false

  $(document).on 'click', '.user-messages-index-item', {}, ->
    url = $(location).attr('href')
    room_id = $(this).data 'room'
    new_url = url.replace /chat_room_id=\d+/, 'chat_room_id=' + room_id
    window.location.href = new_url

  $(document).on 'keydown', '.user-message-new-form textarea', {}, (e)->
    if e.ctrlKey && e.keyCode == 13
      $('.user-message-new-form form').trigger 'submit'

  $(document).on 'keyup', '.chat-rooms-search input', {}, (e)->
    input = e.target
    if $(input).length > 0
      $.ajax {
        url: '/employer/companies/1/company_chat_messages',
        data: {
          candidate_name: $(input).val()
        }
      }
