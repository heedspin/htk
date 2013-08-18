Ember.Handlebars.helper 'from_now', (value, options) ->
	return moment(value).formatTimeToday()
