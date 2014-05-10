$.fn.resetForm = function() {
	this.find('input:text, input:password, input:file, input:hidden, select, textarea').val('');
	this.find('input:radio, input:checkbox').removeAttr('checked').removeAttr('selected');
	return this;
}
