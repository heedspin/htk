# http://mcdowall.info/posts/ember-application-initializers/
Ember.Application.initializer
  name: 'initialize_current_user'

  initialize: (container) ->
  	store = container.lookup('store:main')
  	user = store.find('user', 'current')
  	controller = container.lookup('controller:currentUser').set('content', user)
  	container.typeInjection('controller', 'currentUser', 'controller:currentUser')