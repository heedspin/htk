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
	model: -> this.store.find 'party'

Htk.MessagesRoute = Ember.Route.extend
	enter: ->
		console.log "Entering messages route"
	exit: ->
		console.log "Exiting messages route"		
	setupController: (controller, model) ->
		console.log "MessagesRoute.setupController called"
		party = @modelFor('party')
		controller.setup(party)
		route = this
		loader = ->
			offset = controller.get('totalPartyMessages')
			route.store.find('message', party_id: party.id, limit: 5, offset: offset).then (result) ->
				messages = result.toArray()
				# console.log "Loaded " + messages.length + " - " + (messages.map (msg) -> msg.id).join(', ')
				controller.addMessages(messages)
				if messages.length >= 5
					Ember.run.later(loader, 0)
				else
					controller.setMessagesLoaded()
		loader.call()
		# Ember.run.later(loader, 0)

Htk.MessageRoute = Ember.Route.extend
	observerSet: false
	setupController: (controller, model) ->
		console.log "MessageRoute.setupController called"
		controller.set 'model', model
		setupTime = new Date().getTime()
		selectCurrent = ->
			messages_controller = this.controllerFor('messages')
			messages = messages_controller.get('sortedPartyMessages')
			message_id = this.modelFor('message').get('id')
			console.log setupTime + " selectCurrent running for message " + message_id
			to_select = null
			any_set = false
			messages.forEach (m) ->
				if m.get 'isSelected'
					any_set = true
				if m.get('id') == message_id
					to_select = m
			if !any_set and to_select
				to_select.set 'isSelected', true
				this.set 'observerSet', false
				# messages_controller.removeObserver 'sortedPartyMessages', this, selectCurrent
		unless this.get('observerSet')
			messages_controller = this.controllerFor('messages')
			this.set 'observerSet', true
			messages_controller.addObserver 'sortedPartyMessages', this, selectCurrent

	model: (params) -> 
		console.log "MessageRoute.model called"
		message_id = params.message_id
		this.store.find('message', params.message_id)

Htk.EmailAccountsIndexRoute = Ember.Route.extend
	model: -> this.store.find 'email_account'

Htk.EmailsRoute = Ember.Route.extend
	model: (params) -> 
		email_account = @modelFor('email_account')
		this.set('page', params.page)
		this.set('pageSize', 15)
		this.store.find('email_summary', 
			email_account_id: email_account.id, page: params.page, limit: 15)
	setupController: (controller, model) ->
		controller.set('page', this.get('page'))
		controller.set('pageSize', this.get('pageSize'))
		controller.set('model', model)

Htk.EmailRoute = Ember.Route.extend
	model: (params) -> 
		email_summaries = this.modelFor('emails')
		if Ember.isEmpty(email_summaries) or Ember.isEmpty(email_summaries.content)
			console.log "EmailRoute does not have access to email summaries!"
		else
			email_id = null
			if params.email_id == 'first'
				email_id = email_summaries.get('firstObject').get('id')
			else
				if params.email_id == 'last'
					email_id = email_summaries.get('lastObject').get('id')
				else
					email_id = params.email_id
			to_load = null
			any_set = false
			email_summaries.forEach (es) ->
				if es.get 'isSelected'
					any_set = true
				if es.get('id') == email_id
					to_load = es
			if !any_set and to_load
				to_load.set 'isSelected', true
		this.store.find('email', email_id)

Htk.LoadingRoute = Ember.Route.extend({})

