function SelectBinding(jqe, model, attribute_key, debug_strings) {
	HtkBinding.call(this, 'SelectBinding: ', jqe, model, attribute_key, debug_strings);
	var _this = this;
	this.jqe.change(function() {
		var value = _this.jqe.val();
		htkLog("SelectBinding: " + _this.debug_strings + " changed to " + value);
		_this.model.set(_this.attribute_key, value, _this.id);
	});
}

SelectBinding.prototype = Object.create(HtkBinding.prototype, {
	set : {
		value : function(value) {
			htkLog("SelectBinding: setting " + this.debug_strings + " to " + (value || ""));
			this.jqe.filter(function() {
    		return $(this).attr("id") == value;
			}).prop('selected', true);
		}
	}
});

HtkBinding.prototype.register('SELECT', SelectBinding);
