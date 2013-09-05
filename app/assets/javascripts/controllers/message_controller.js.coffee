Htk.MessageController = Ember.ObjectController.extend
	needs: ['messages']

	# http://jsfiddle.net/pangratz666/ZTdPF/
	showHideText: (->
		if @get('message.hidden') then 'Show' else 'Hide'
	).property('message.hidden')

	actions:
		toggleVisibility: ->
			message = @get('message')
			message.toggleProperty('hidden')
			message.save()

			# messages = this.get("controllers.messages")
			# message = messages.findBy('id', @get('message').get('id'))
			# message.set('hidden', @get('hidden'))
