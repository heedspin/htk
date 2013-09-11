Htk.EmailsController = Ember.ArrayController.extend
	needs: ['email_account', 'emails']	
	email_account: null
	email_accountBinding: "controllers.email_account"
	# emails: null
	# emailsBinding: 'controllers.emails'
	pageSize: null
	page: null
	hasPreviousPage: ( ->
		return !(this.get('page') == 'top')
	).property('content.@each')
	hasNextPage: ( ->
		return this.get('content').get('length') == this.get('pageSize')
	).property('content.@each')
	actions:
		previousPage: ->
			currentPage = parseInt(this.get('page'))
			newPage = currentPage - 1
			if newPage == 1
				newPage = 'top'
			console.log "Going to previous page " + newPage + " from " + currentPage
			this.transitionToRoute('emails', newPage)
			# this.set('content', Htk.Email.find(email_account_id: this.get('email_account').get('id'), page: newPage))
			# this.set('page', newPage)
		nextPage: ->
			currentPage = this.get('page')
			if currentPage == 'top'
				newPage = 2
			else
				newPage = parseInt(currentPage) + 1
			console.log "Going to next page " + newPage + " from " + currentPage
			this.transitionToRoute('emails', newPage)
			# this.set('content', Htk.Email.find(email_account_id: this.get('email_account').get('id'), page: newPage))
			# this.set('page', newPage)
		selectEmail: (email) ->
			# @setEach 'isSelected', false
			# email.set 'isSelected', true
			this.transitionToRoute('email', this.get('page'), email.id)