function HtkBinding(logPrefix, jqe, model, attribute_key, debug_strings) {
	this.id = ++HtkBinding.prototype.ids;
	this.logPrefix = logPrefix;
	this.jqe = jqe;
	this.model = model;
	this.attribute_key = attribute_key;
	if (debug_strings) {
		if (debug_strings instanceof Array) {
			this.debug_strings = _.compact(debug_strings).join(" ");
		} else {
			this.debug_strings = debug_strings || "";				
		}
	} else {
		this.debug_strings = "";
	}
}

HtkBinding.prototype = Object.create(Object.prototype, {
	set : {
		value : function(value) {
			htkLog(this.logPrefix + "setting " + this.debug_strings + " to " + (value || ""));
		}
	}
});

HtkBinding.prototype.ids = 0;

HtkBinding.prototype.registry = new Object();

HtkBinding.prototype.register = function(tagName, constructor) {
	HtkBinding.prototype.registry[tagName] = constructor;
	htkLog("HtkBinding: registered " + tagName);
}

HtkBinding.prototype.create = function(jqe, model, attribute_key, debug_strings) {
	var tagName = jqe.prop("tagName");
	var binding_type = HtkBinding.prototype.registry[tagName];
	if (binding_type) {
		htkLog("HtkBinding: created for " + tagName);
		return new binding_type(jqe, model, attribute_key, debug_strings);		
	} else {
		throw "HtkBinding: no binding for " + tagName + " (" + debug_strings + ")";
	}
}
