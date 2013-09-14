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
		this.propertyWillChange('sortedPartyMessages')
		partyMessages = this.get 'partyMessages'
		shownMessages = this.get 'shownMessages'
		sortedPartyMessages = this.get 'sortedPartyMessages'
		for message in messages
			partyMessages[message.get('id')] = message
			sortedPartyMessages.addObject message
			@incrementProperty('totalPartyMessages')
			if !message.get('hidden')
				shownMessages.addObject message
		console.log "MessagesController.addMessages totalPartyMessages = " + this.get('totalPartyMessages') + " shownMessages = " + shownMessages.length
		this.propertyDidChange('sortedPartyMessages')
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

		selectMessage: (message) ->
			this.get('sortedPartyMessages').forEach (msg) ->
				msg.set 'isSelected', false
			message.set 'isSelected', true
			this.transitionToRoute('message', message.id)

		moveDown: (event) ->    
			console.log "Messages Controller Move Down"
			all_messages = this.get('shownMessages')
			first_message = all_messages.get('firstObject')
			last_message = all_messages.get('lastObject')
			selected = null
			transitionToMessage = null
			all_messages.toArray().some (message, index, array) ->
				if selected
					transitionToMessage = message
					true
				else
					if message.get("isSelected")
						selected = message
						if message == last_message
							transitionToMessage = first_message
							true
						else
							false
			transitionToMessage ||= first_message
			if selected
				selected.set("isSelected", false)
			transitionToMessage.set("isSelected", true)
			this.transitionToRoute('message', transitionToMessage)
			false

		moveUp: (event) ->    
			console.log "Messages Controller Move Up"
			all_messages = this.get('shownMessages')
			first_message = all_messages.get('firstObject')
			last_message = all_messages.get('lastObject')
			previous = null
			selected = null
			transitionToMessage = null
			all_messages.toArray().some (message, index, array) ->
				if message.get("isSelected")
					selected = message
					if (message == first_message)
						transitionToMessage = last_message
					else
						transitionToMessage = previous
					true
				else
					previous = message
					false
			if transitionToMessage
				selected.set("isSelected", false) if selected
				transitionToMessage.set('isSelected', true)
				this.transitionToRoute('message', transitionToMessage)
			false

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
