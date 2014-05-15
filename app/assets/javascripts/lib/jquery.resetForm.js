$.fn.resetForm = function(not_selector) {
	var selection = this.find('input:text, input:password, input:file, input:hidden, select, textarea');
	if (not_selector) {
		selection = selection.not(not_selector);
	}
	selection.val('');
	selection = this.find('input:radio, input:checkbox');
	if (not_selector) {
		selection = selection.not(not_selector);
	}
	selection.removeAttr('checked').removeAttr('selected');
	return this;
}
