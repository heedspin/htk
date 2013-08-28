Ember.Handlebars.registerBoundHelper 'emailAddresses', (addresses, options) ->
	max_length = options.hash.max_length || 1024;
	result = null
	if Ember.isArray(addresses)
		result = (addresses.map (address) -> address.get('short_name')).sort().join(', ')
	else
		result = addresses.get('short_name')
	if result.length > max_length
		return result.substring(0,max_length)+'...'
	else
		return result
