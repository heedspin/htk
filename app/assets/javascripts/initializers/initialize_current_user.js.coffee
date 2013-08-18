Ember.Application.initializer
  name: 'initialize_current_user'

  initialize: (container) ->
    user = Htk.User.find('current')
    controller = container.lookup('controller:currentUser').set('content', user)
    container.typeInjection('controller', 'currentUser', 'controller:currentUser')