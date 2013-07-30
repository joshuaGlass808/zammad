class Index extends App.Controller
  constructor: ->
    super

    # check authentication
    return if !@authenticate()

    new App.ControllerGenericIndex(
      el: @el
      id: @id
      genericObject: 'User'
      defaultSortBy: 'login'
      ignoreObjectIDs: [1]
      pageData:
        title:     'Users'
        home:      'users'
        object:    'User'
        objects:   'Users'
        navupdate: '#users'
        notes: [
          'Users are for any person in the system. Agents (Owners, Resposbiles, ...) and Customers.'
        ]
        buttons: [
#          { name: 'List', 'data-type': '', class: 'active' },
          { name: 'New User', 'data-type': 'new', class: 'primary' }
        ]
    )

App.Config.set( 'User', { prio: 1000, name: 'Users', parent: '#manage', target: '#manage/users', controller: Index, role: ['Admin'] }, 'NavBarLevel44' )
