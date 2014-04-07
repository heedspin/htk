$.fn.resetForm = function() {
	this.find('input:text, input:password, input:file, select, textarea').val('');
	this.find('input:radio, input:checkbox').removeAttr('checked').removeAttr('selected');
	return this;
}
