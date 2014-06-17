Handlebars.registerHelper("selected", function(isSelected, options) {
	if (isSelected) {
		return "selected";
	} else {
		return null;
	}
});

Handlebars.registerHelper("selected_by_member", function(object, member, options) {
	if (object[member]) {
		return "selected";
	} else {
		return null;
	}
});

Handlebars.registerHelper("completed", function(completedById, options) {
	if (completedById) {
		return "completed";
	} else {
		return null;
	}
});

Handlebars.registerHelper("join", function(array, separator, options) {
	return _.map(array, function(i) { return options.fn(i); }).join(separator);
});

Handlebars.registerHelper("date", function(date) {
	return moment(date).format('MMMM Do YYYY');
});

Handlebars.registerHelper("datetime", function(date) {
	return moment(date).format('MMMM Do YYYY, h:mm:ss a');
});

Handlebars.registerHelper("fromNow", function(date) {
	return moment(date).fromNow();
});

Handlebars.registerHelper('simple_format', function(text) {
  text = Handlebars.Utils.escapeExpression(text);
	return new Handlebars.SafeString(text.replace(/\n/g, '<br />'));
});

Handlebars.registerHelper('completion_comment_title', function(comment_type) {
	return new Handlebars.SafeString(comment_type.name);
});
