Handlebars.registerHelper("selected", function(isSelected, options) {
	if (isSelected) {
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