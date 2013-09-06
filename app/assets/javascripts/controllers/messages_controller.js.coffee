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