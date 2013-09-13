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
		moveDown: ->    
			console.log "Emails Controller Move Down"
			currentPage = this.get('page')
			all_emails = this.get('content')
			first_email = all_emails.get('firstObject')
			last_email = all_emails.get('lastObject')
			selected_email = null
			transitionToPage = null
			transitionToEmail = null
			all_emails.toArray().some (email, index, array) ->
				if selected_email
					transitionToEmail = email.id
					transitionToPage = currentPage
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
			if transitionToEmail
				this.transitionToRoute('email', transitionToPage, transitionToEmail)
			else
				this.transitionToRoute('email', currentPage, first_email.get('id'))
			event.preventDefault()

		moveUp: ->    
			console.log "Emails Controller Move Up"
			currentPage = this.get('page')
			all_emails = this.get('content')
			first_email = all_emails.get('firstObject')
			previous_email = null
			transitionToPage = null
			transitionToEmail = null
			all_emails.toArray().some (email, index, array) ->
				if email.get("isSelected")
					if (email == first_email)
						if currentPage == 1
							true
						else
							transitionToPage = parseInt(currentPage) - 1
							transitionToEmail = 'last'
							true
					else
						transitionToPage = currentPage
						transitionToEmail = previous_email.id
						true
				else
					previous_email = email
					false
			if transitionToEmail
				this.transitionToRoute('email', transitionToPage, transitionToEmail)
			event.preventDefault()