class App.UserInfo extends App.Controller
  events:
    'focusout [data-type=update]': 'update',
    'click [data-type=edit]': 'edit'

  constructor: ->
    super

    # show user
    callback = (user) =>
      @render(user)
      if @callback
        @callback(user)

      # subscribe and reload data / fetch new data if triggered
      @subscribeId = user.subscribe(@render)

    App.User.retrieve( @user_id, callback )

  release: =>
    App.User.unsubscribe(@subscribeId)

  render: (user) =>
    if !user
      user = @u

    # get display data
    data = []
    for item2 in App.User.configure_attributes
      item = _.clone( item2 )

      # check if value for _id exists
      itemNameValue = item.name
      itemNameValueNew = itemNameValue.substr( 0, itemNameValue.length - 3 )
      if itemNameValueNew of user
        item.name = itemNameValueNew

      # add to show if value exists
      if user[item.name]

        # do not show firstname and lastname / already show via diplayName()
        if item.name isnt 'firstname' && item.name isnt 'lastname' && item.name isnt 'organization'
          if item.info
            data.push item

    # insert data
    @html App.view('user_info')(
      user: user
      data: data
    )

    @userTicketPopups(
      selector: '.user-tickets'
      user_id:  user.id
      position: 'right'
    )

  # update changes
  update: (e) =>
    note = $(e.target).parent().find('[data-type=update]').val()
    user = App.User.find( @user_id )
    if user.note isnt note
      user.updateAttributes( note: note )
      @log 'notice', 'update', e, note, user

  edit: (e) =>
    e.preventDefault()
    new App.ControllerGenericEdit(
      id: @user_id,
      genericObject: 'User',
      required: 'quick',
      pageData: {
        title: 'Users',
        object: 'User',
        objects: 'Users',
      },
      callback: @render
    )
