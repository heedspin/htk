Htk.MessageSearchInput = Ember.View.extend
	input: ->
		value = @get('searchInput')
		# console.log "MessageSearchInput: " + value
		@get('controller').send('search', value)
