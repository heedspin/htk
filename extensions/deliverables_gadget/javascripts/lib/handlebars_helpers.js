Handlebars.registerHelper("selected", function(isSelected, options) {
	if (isSelected) {
		return "selected";
	} else {
		return null;
	}
});