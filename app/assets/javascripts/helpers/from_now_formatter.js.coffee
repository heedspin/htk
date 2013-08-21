Ember.Handlebars.helper 'from_now', (value, options) ->
	if Ember.isEmpty(value)
		return ''
	else
		return moment(value).formatTimeToday()
