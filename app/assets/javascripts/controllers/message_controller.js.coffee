Htk.MessageController = Ember.ObjectController.extend
	needs: ['messages']

	# http://jsfiddle.net/pangratz666/ZTdPF/
	showHideText: (->
		if @get('message').get('hidden') then 'Show' else 'Hide'
	).property('message.hidden')

	actions:
		toggleVisibility: ->
			@toggleProperty('message.hidden')
			# messages = this.get("controllers.messages")
			# message = messages.findBy('id', @get('message').get('id'))
			# message.set('hidden', @get('hidden'))
			@get('store').commit()
