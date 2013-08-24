Ember.Handlebars.registerBoundHelper 'emailAddresses', (addresses) ->
	result = []
	result.push address.get('address') for address in addresses
	console.dir result
	# address_strings = addresses.map (address) -> address.get('address')
	return result.join(', ')
