Htk.MessagesController = Ember.ArrayController.extend
	party: null
	# needs: ['party']
	breadcrumbs: ( ->
		return [
			{name: 'Party: ' + this.get('party').get('name'), route: 'party'}
		]
	).property()
	sortProperties: ['date']
	sortAscending: false

	showHidden: false
	toggleShowHidden: (->
	  if @get('showHidden')
	    $(".messages table tbody tr.hidden").show()
	  else
	    $(".messages table tbody tr.hidden").hide()
	).observes('showHidden')

	actions:
		loadMore: ->
			console.log "LOAD MORE"
			controller = this
			this.store.find('message', party_id: @get('party').id, limit: 5, offset: 5).then (result) ->
				messages = result.toArray()
				console.log "Loaded " + messages.length + " - " + (messages.map (msg) -> msg.id).join(', ')
				controller.set 'content', controller.get('content').toArray().concat(messages)
