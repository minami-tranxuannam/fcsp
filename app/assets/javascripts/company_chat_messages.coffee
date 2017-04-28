jQuery(document).on 'ready', ->
  messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))
  messages = $('.user-message-items')
  notification = $('a.message-notification')
  badge = $(notification).find('.badge')
  company_badge = $('.fa-envelope-o').next()
  console.log company_badge
  avatar_holder = $('.avatar-holder').find('img')[0]
  App.company_chat = App.cable.subscriptions.create {
    channel: "NotificationsChannel"
  },
  send_message: (content, company_chat_room_id, company_id) ->
    @perform 'send_message', content: content, company_chat_room_id: company_chat_room_id, company_id: company_id

  connected: ->

  disconnected: ->

  received: (data) ->
    if messages.length > 0
      messages.append render_message(data)
      chat_room = $('li#'+data['company_chat_room_id'])
      $(chat_room).replaceWith render_room(data)
      url = $(location).attr('href')
      if url.indexOf('chat_room_id=' + data['company_chat_room_id']) > -1
        setTimeout (->
          $('li#' + data['company_chat_room_id']).removeClass 'user-message-info-new'
        ), 2000
      messages_to_bottom()
    else
      $(company_badge).html data['unread_messages_count']
      console.log data['unread_messages_count']
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

  render_message = (data)->
    "<li class=\"user-message-item\">
      <div class=\"user-message-sender\">
        <div class=\"user-message-sender-avatar\">
          #{$(avatar_holder).prop "outerHTML"}
        </div>
        <div class=\"user-message-info-wrapper\">
          <div class=\"user-message-sender-info\">
            <a href=\"javascript:;\">
              <span class=\"user-message-sender-name\">
                #{data['senderable'].name}
              </span>
            </a>
            <div class=\"user-message-sender-date\">
              #{I18n.strftime(new Date(data['message'].created_at), "%m-%d-%Y")}
            </div>
          </div>
        </div>
      </div>
      <p class=\"user-message-item-content\">
        #{data['message'].content}
      </p>
    </li>"

  render_room = (data)->
    "<li id=\"#{data['company_chat_room_id']}\" class=\"user-message-info-new\">
      <div class=\"user-messages-index-item\" data-room=\"#{data['company_chat_room_id']}\">
        <div class=\"company-profile\">
          <img src=\"https://dubpy8abnqmkw.cloudfront.net/images/anonymous/anonymous-company.png\" height=\"50px\">
        </div>
        <div class=\"user-message-info\" >
          <div class=\"user-message-info-heading\">
            <p class=\"user-message-company-name\"></p>
            <p class=\"user-message-date\">less than a minute</p>
          </div>
          <div class=\"user-message-lastest-message\">
            <p>#{data['message'].content}</p>
          </div>
          <a href=\"/jobs/#{data['job'].id}\">#{data['job'].title}</a>
        </div>
      </div>
    </li>"

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
