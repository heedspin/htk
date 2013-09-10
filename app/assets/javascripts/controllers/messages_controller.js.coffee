Htk.MessagesController = Ember.Controller.extend
	party: null
	partyMessages: null
	sortedPartyMessages: null
	totalPartyMessages: null
	shownMessages: null
	messagesLoaded: false
	searchIndex: null
	breadcrumbs: ( ->
		return [
			{name: 'Party: ' + this.get('party').get('name'), route: 'party'}
		]
	).property()
	sortProperties: ['date']
	sortAscending: false
	searchEngineReady: (->
		this.get('searchIndex').get('searchEngineReady')
	).observes('searchIndex.searchEngineReady')

	setup: (party) ->
		this.set 'party', party
		this.set 'messagesLoaded', false
		this.set 'partyMessages', {}
		this.set 'sortedPartyMessages', []
		this.set 'totalPartyMessages', 0
		this.set 'searchIndex', Htk.MessageSearchIndex.create()
		this.set 'shownMessages', []
		console.log "MessagesController setup"

	addMessages: (messages) ->
		partyMessages = this.get 'partyMessages'
		shownMessages = this.get 'shownMessages'
		sortedPartyMessages = this.get 'sortedPartyMessages'
		for message in messages
			partyMessages[message.get('id')] = message
			sortedPartyMessages.push message
			@incrementProperty('totalPartyMessages')
			if !message.get('hidden')
				shownMessages.addObject message
		console.log "MessagesController totalPartyMessages = " + this.get('totalPartyMessages') + " shownMessages = " + shownMessages.length
		true

	setMessagesLoaded: ->
		this.set('messagesLoaded', true)
		this.get('searchIndex').index(this.get('party').get('id'), this.get('sortedPartyMessages'))
		console.log "Messages done loading"

	showHidden: false
	toggleShowHidden: (->
	  if @get('showHidden')
	    $(".messages table tbody tr.hidden").show()
	  else
	    $(".messages table tbody tr.hidden").hide()
	).observes('showHidden')

	actions:
		search: (text) ->
			if Ember.isEmpty?(text) || Ember.isEmpty?(text.trim())
				this.set('shownMessages', this.get('sortedPartyMessages'))
			else
				_this = this
				this.get('searchIndex').search text, (resultset) ->
					newShownMessages = []
					if resultset and resultset.getSize()
						console.log "Search found " + resultset.getSize()
						partyMessages = _this.get('partyMessages')
						resultset.forEach (message_id) ->
							if (message = partyMessages[message_id]) and !message.get('hidden')
								newShownMessages.addObject partyMessages[message_id]
					else
						console.log "No result found :-("
					_this.set 'shownMessages', newShownMessages
