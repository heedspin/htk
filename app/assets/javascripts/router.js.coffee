Htk.Router.map ->
	this.resource 'parties', ->
		this.resource 'party', { path: ':party_id' }, ->
			this.resource 'messages', ->

	this.resource 'email_accounts', ->
		this.resource 'email_account', { path: ':email_account_id'}, ->
			this.resource 'emails', { path: ':page' }

# @route 'parties', path: '/'

Htk.PartiesIndexRoute = Ember.Route.extend
	model: -> Htk.Party.find()

# Htk.PartyIndexRoute = Ember.Route.extend
# 	model: (params) -> Htk.Party.find(params.party_id)

Htk.MessagesIndexRoute = Ember.Route.extend
	setupController: (controller, model) ->
		party = @modelFor('party')
		controller.set('model', Htk.Message.find(party_id: party.id))
		controller.set('party', party)

	# model: (params) -> Htk.Message.find(party_id: @modelFor('party').id)
		# @controllerFor('party').get('messages')

# Htk.MessageRoute = Ember.Route.extend
# 	model: (params) -> Htk.Message.find(params.message_id)

Htk.EmailAccountsIndexRoute = Ember.Route.extend
	model: -> Htk.EmailAccount.find()

# Htk.EmailAccountIndexRoute = Ember.Route.extend
# 	model: (params) -> return Htk.EmailAccount.find(params.email_account_id)

Htk.EmailsRoute = Ember.Route.extend
	model: (params) -> 
		email_account = @modelFor('email_account')
		this.set('page', params.page)
		this.set('pageSize', 15)
		Htk.Email.find(email_account_id: email_account.id, page: params.page, limit: 15)
	setupController: (controller, model) ->
		controller.set('page', this.get('page'))
		controller.set('pageSize', this.get('pageSize'))
		controller.set('model', model)
