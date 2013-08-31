Htk.MessageController = Ember.ObjectController.extend
	needs: ['messages']

	# http://jsfiddle.net/pangratz666/ZTdPF/
	showHideText: (->
		if @get('hidden') then 'Show' else 'Hide'
	).property('hidden')

	actions:
		toggleVisibility: ->
			@toggleProperty('hidden')
			messages = this.get("controllers.messages")
			message_summary = messages.findBy('id', @get('id'))
			message_summary.set('hidden', @get('hidden'))
			message_summary.set('active', false)
			@get('store').commit()
			# debugger
