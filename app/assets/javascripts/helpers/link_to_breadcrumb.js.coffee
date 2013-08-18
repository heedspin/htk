Ember.Handlebars.registerBoundHelper 'linkToBreadcrumb', (crumb, options) ->
	options.fn = (x) -> return crumb.name
	args = [crumb.route, options];
	result = Ember.Handlebars.helpers.linkTo.apply this, args
	return result
