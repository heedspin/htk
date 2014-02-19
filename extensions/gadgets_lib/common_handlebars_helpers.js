Handlebars.registerHelper('link', function(text, url) {
  text = Handlebars.Utils.escapeExpression(text);
	var result = null;
	if (url) {
	  url  = Handlebars.Utils.escapeExpression(url);
	  result = '<a href="' + url + '">' + text + '</a>';		
	} else {
		result = url;
	}
  return new Handlebars.SafeString(result);
});

Handlebars.registerHelper('name', function(id, first_name, last_name) {
	var result = null;
	if (currentUser && (currentUser.id == id)) {
		result = 'me';
	} else {
		result = first_name
	}
	return result;
});

Handlebars.registerHelper('simple_format', function(text) {
  text = Handlebars.Utils.escapeExpression(text);
	return new Handlebars.SafeString(text.replace(/\n/g, '<br />'));
});

Handlebars.registerHelper('if_equal', function(a,b,options) {
	if (a == b) {
		return options.fn(this);
	} else {
		return options.inverse(this);
	}
});