Htk.MessagesIndexController = Ember.ArrayController.extend
	party: null
	# needs: ['party']
	breadcrumbs: ( ->
		return [
			{name: 'Party: ' + this.get('party').get('name'), route: 'party'}
		]
	).property()
	
	