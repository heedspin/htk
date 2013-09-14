Htk.MessageController = Ember.ObjectController.extend
	needs: ['messages']
	sortedMessages: null

	# http://jsfiddle.net/pangratz666/ZTdPF/
	showHideText: (->
		if @get('model.hidden') then 'Show' else 'Hide'
	).property('model.hidden')

	actions:
		toggleVisibility: ->
			message = @get('model')
			message.toggleProperty('hidden')
			message.save()

			# messages = this.get("controllers.messages")
			# message = messages.findBy('id', @get('message').get('id'))
			# message.set('hidden', @get('hidden'))
