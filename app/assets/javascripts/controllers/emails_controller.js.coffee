Htk.EmailsController = Ember.ArrayController.extend
	needs: ['email_account', 'emails']	
	email_account: null
	email_accountBinding: "controllers.email_account"
	# emails: null
	# emailsBinding: 'controllers.emails'
	pageSize: null
	page: null
	hasPreviousPage: ( ->
		return !(this.get('page') == 1)
	).property('content.@each')
	hasNextPage: ( ->
		return this.get('content').get('length') == this.get('pageSize')
	).property('content.@each')

	timerId: null
	delayedSelectEmail: (page, email_id) ->
		_this = this
		if timerId = this.get('timerId')
			_this.set("timerId", null)
			Ember.run.cancel timerId
			console.log "Cancelling timer " + timerId
		f = ->
			console.log "Timer fired!"
			_this.set("timerId", null)
			_this.transitionToRoute('email', page, email_id)
		# debugger
		timerId = Ember.run.later f, 500
		this.set 'timerId', timerId

	actions:
		previousPage: ->
			currentPage = parseInt(this.get('page'))
			newPage = currentPage - 1
			console.log "Going to previous page " + newPage + " from " + currentPage
			this.transitionToRoute('emails', newPage)
			# this.set('content', Htk.Email.find(email_account_id: this.get('email_account').get('id'), page: newPage))
			# this.set('page', newPage)
		nextPage: ->
			currentPage = this.get('page')
			newPage = parseInt(currentPage) + 1
			console.log "Going to next page " + newPage + " from " + currentPage
			this.transitionToRoute('emails', newPage)
			# this.set('content', Htk.Email.find(email_account_id: this.get('email_account').get('id'), page: newPage))
			# this.set('page', newPage)
		selectEmail: (email) ->
			# @setEach 'isSelected', false
			# email.set 'isSelected', true
			this.transitionToRoute('email', this.get('page'), email.id)

		moveDown: (event) ->    
			console.log "Emails Controller Move Down"
			currentPage = this.get('page')
			all_emails = this.get('content')
			first_email = all_emails.get('firstObject')
			last_email = all_emails.get('lastObject')
			selected_email = null
			transitionToPage = currentPage
			transitionToEmail = null
			all_emails.toArray().some (email, index, array) ->
				if selected_email
					transitionToEmail = email
					true
				else
					if email.get("isSelected")
						if email == last_email
							transitionToEmail = 'first'
							transitionToPage = parseInt(currentPage) + 1
							true
						else
							selected_email = email
							false
			transitionToEmail ||= first_email
			if selected_email
				selected_email.set("isSelected", false)
			unless transitionToEmail == 'first'
				transitionToEmail.set("isSelected", true)
				transitionToEmail = transitionToEmail.get('id')
			this.delayedSelectEmail(transitionToPage, transitionToEmail)
			false

		moveUp: (event) ->    
			console.log "Emails Controller Move Up"
			currentPage = this.get('page')
			all_emails = this.get('content')
			first_email = all_emails.get('firstObject')
			previous_email = null
			selected_email = null
			transitionToPage = currentPage
			transitionToEmail = null
			all_emails.toArray().some (email, index, array) ->
				if email.get("isSelected")
					selected_email = email
					if (email == first_email)
						if currentPage == 1
							true
						else
							transitionToPage = parseInt(currentPage) - 1
							transitionToEmail = 'last'
							true
					else
						transitionToEmail = previous_email
						true
				else
					previous_email = email
					false
			if transitionToEmail
				selected_email.set("isSelected", false) if selected_email
				transitionToEmail.set('isSelected', true)
				transitionToEmail = transitionToEmail.get('id') unless transitionToEmail == 'last'
				this.delayedSelectEmail(transitionToPage, transitionToEmail)
			false

