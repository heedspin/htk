Htk.Router.map ->
	this.resource 'parties', ->
		this.resource 'party', { path: ':party_id' }, ->
			this.resource 'messages', ->
				this.resource 'message', { path: ':message_id' }

	this.resource 'email_accounts', ->
		this.resource 'email_account', { path: ':email_account_id'}, ->
			this.resource 'emails', { path: ':page' }, ->
				this.resource 'email', { path: ':email_id' }

Htk.PartiesIndexRoute = Ember.Route.extend
	model: -> Htk.Party.find()

Htk.MessagesRoute = Ember.Route.extend
	setupController: (controller, model) ->
		party = @modelFor('party')
		controller.set('model', Htk.Message.find(party_id: party.id))
		controller.set('party', party)

Htk.MessageRoute = Ember.Route.extend
	model: (params) -> 
		Htk.MessageBody.find(params.message_id)

Htk.EmailAccountsIndexRoute = Ember.Route.extend
	model: -> Htk.EmailAccount.find()

Htk.EmailsRoute = Ember.Route.extend
	model: (params) -> 
		email_account = @modelFor('email_account')
		this.set('page', params.page)
		this.set('pageSize', 15)
		Htk.EmailSummary.find(email_account_id: email_account.id, page: params.page, limit: 15)
	setupController: (controller, model) ->
		controller.set('page', this.get('page'))
		controller.set('pageSize', this.get('pageSize'))
		controller.set('model', model)

Htk.EmailRoute = Ember.Route.extend
	model: (params) -> 
		Htk.Email.find(params.email_id)
