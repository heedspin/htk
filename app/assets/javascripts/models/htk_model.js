function HtkModel(attributes) {
	this.id = null;
	this.changes = [];
	this.bindings = new Object();
	this.set_attributes(attributes);
	if (this.attribute_keys.size == 0) {
		var _this = this;
		var add_attribute_key = function(a) {
			for (var property in a) {	_this.attribute_keys.push(property); }
		}
		if (attributes instanceof Array) {
			_.each(attributes, add_attribute_key);
		} else {
			add_attribute_key(attributes);
		}
	}
}

HtkModel.prototype = Object.create(Object.prototype, {
	gadget_keys : {
		value : ["opensocial_owner_id", "from_address", "to_addresses", "cc_addresses", "date", "subject", "web_id"]
	},
	api_url : { value : function() {} },
	type_key : { value : null },
	attribute_keys : { value : [] },
	attributes : {
		value : function() {
			var result = new Object();
			var _self = this;
			_.each(this.attribute_keys.concat(this.gadget_keys), function(attribute_key) {
				var value = _self[attribute_key];
				if (typeof(value) !== "undefined") {
					result[attribute_key] = value;
				}
			});
			return result;
		}
	},
	reset_changes : { value : function() { this.changes = []; }},
	changed : { value : function() { return (this.changes.length > 0); } },
	set : {
		value : function(key, value, exclude_binding_id) {
			if ((typeof(this[key]) === "undefined") || (this[key] != value)) {
				this.changes.push({
					attribute : key,
					previous_value : this[key],
					new_value : value
				});
				this[key] = value;
				var attribute_bindings = this.bindings[key];
				if (attribute_bindings) {
					_.each(attribute_bindings, function(b) {
						if (!exclude_binding_id || (exclude_binding_id != b.id))
							b.set(value); 
					});
				}
			}
		}
	},
	set_attributes_by_obj : {
		value : function(obj) {
			for (var property in obj) {
	    	this.set(property, obj[property]);
		    // if (obj.hasOwnProperty(property)) {
		    // }
			}
		}
	},
	set_attributes : {
		value : function(thing) {
			if (thing instanceof Array) {
				_.each(thing, this.set_attributes_by_obj, this);
			} else {
				this.set_attributes_by_obj(thing);
			}
		}
	},
	save : {
		value : function(callbacks) {
			this.add_joiner(callbacks);
			if (this.changes.length > 0) {
				if (!this.id) {
					this.create(callbacks);
				} else {
					this.update(callbacks);
				}
			}
		}
	},
	create : {		
		value : function(callbacks) {
			this.add_joiner(callbacks);
	    var _this = this;
	    htkRequest("POST", this.api_url(), this.attributes(), function(obj) {
	    	var results = _this.update_single(obj);
	    	_this.reset_changes();
				HtkModel.prototype.cache.set(_this.type_key, _this);
	    	_this.handle_callbacks(results, callbacks);
	    });
		}
	},
	update : {		
		value : function(callbacks) {
			this.add_joiner(callbacks);
	    var _this = this;
	    htkRequest("PUT", this.api_url() + "/" + this.id, this.attributes(), function(obj) {
	    	var results = _this.update_single(obj);
	    	_this.reset_changes();
	    	_this.handle_callbacks(results, callbacks);
	    });
		}
	},
	receive_object : {
		value : function(model_constructor, data) {
			var object = HtkModel.prototype.cache.get(model_constructor.prototype.type_key, data.id);
			if (object) {
				object.set_attributes(data);
			} else {
				object = new model_constructor(data);
				HtkModel.prototype.cache.set(model_constructor.prototype.type_key, object);
			}
			object.reset_changes();
			return object;
		}
	},
	extract : {
		value : function(obj) {
			var _this = this;
			var created = [];
			var results = new Object( { obj : obj });
			for (var property in obj.data) {
				var model_constructor = HtkModelRegistry.prototype.constructor_for(property);
				if (model_constructor) {
					var v = obj.data[property];
					if (v instanceof Array) {
						results[property] = _.map(v, function(d) { 
							var new_object = _this.receive_object(model_constructor, d);
							created.push(new_object);
							return new_object;
						});
					} else {
						var new_object = this.receive_object(model_constructor, v);
						created.push(new_object);
						results[property] = new_object
					}
				}
			}
			_.each(created, function(o) { o.registry_hook() });
			return results;
		}
	},
	update_single : {
		value : function(obj) {
			var results = this.extract(obj);
			results[this.type_key] = this;
		  this.set_attributes(obj.data[this.type_key]);
		  this.reset_changes();
		  this.registry_hook();
		  return results;
		}
	},
	registry_hook : {
		value : function() {}
	},
	handle_callbacks : {
		value : function(results, callbacks) {
		  if (!results.obj || (results.obj.rc && results.obj.rc == 200)) {
		  	if (callbacks && callbacks.success && typeof(callbacks.success) === "function") {  
		  		callbacks.success(results);
				}
		  } else {
		  	if (callbacks && callbacks.error && typeof(callbacks.error) === "function") {  
		  		callbacks.error(results);
				} else {
			    htkLog("Unhandled error: " + JSON.stringify(results.obj));			
				}
		  }
	  	if (callbacks && callbacks.joiner) {  
	  		callbacks.joiner.remove();
			}
		}
	},
	add_joiner : {
		value : function(callbacks) {
	  	if (callbacks && callbacks.joiner) {  
	  		callbacks.joiner.add();
			}
		}
	},
	all : {
		value : function(query_data, callbacks) {
			this.add_joiner(callbacks);
			var _this = this;
			htkRequest("GET", this.api_url(), query_data, function(obj) {
				var results = _this.extract(obj);
				_this.handle_callbacks(results, callbacks);
			});
		}
	},
	cache : {
		value : (new HtkObjectCache())
	},
	find_cached : {
		value : function(id) {
			return HtkModel.prototype.cache.get(this.type_key, id);
		}
	},
	first_cached : {
		value : function(query) {
			var result = HtkModel.prototype.cache.all(this.type_key, query);
			return result[0];
		}
	},
	all_cached : {
		value : function(query) {
			return HtkModel.prototype.cache.all(this.type_key, query);
		}
	},
	find : {
		value : function(id, callbacks) {
			this.add_joiner(callbacks);
			var cached = this.find_cached(id);
			if (cached) {
				var results = new Object();
				results[this.type_key] = cached;
				this.handle_callbacks(results, callbacks);
			} else {
				var _this = this;
				htkRequest("GET", this.api_url() + "/" + id, null, function(obj) {
					var results = _this.extract(obj);
					_this.handle_callbacks(results, callbacks);
				});
			}
		}
	},
	destroy : {
		value : function(callbacks) {
			this.add_joiner(callbacks);
			var _this = this;
		  htkRequest("DELETE", this.api_url() + "/" + this.id, null, function(obj) {
		    var rc = "";
		    if (obj.rc) rc = obj.rc;
		    if (rc == 200) {
		    	// Leave it in there! HtkModel.prototype.cache.clear(_this.type_key, _this.id);
			    if (callbacks.success && (typeof(callbacks.success) === "function")) callbacks.success(obj);
		    } else {
			    if (callbacks.error && (typeof(callbacks.error) === "function")) callbacks.error(obj);
		    }
		  });	
		}
	},
	bind : {
		value : function(jqe, debug_message) {
			_this = this;
			jqe.find("data-bind").each(function(i) {
				var element = $(this);
				var markup_name = element.attr("data-bind");
				if (markup_name) {
					if (_.contains(_this.attribute_keys, markup_name)) {
						htkLog("Binding " + markup_name);
						_this.addBinding(markup_name, new HtkBinding(element, [debug_message, markup_name]));
					}
				}
			});
		}
	},
	bindForm : {
		value : function(jqf, debug_message) {
			_this = this;
			jqf.find("input, select, textarea").each(function(i) {
				var element = $(this);
				var markup_name = element.attr("name");
				if (markup_name) {
					_this.attribute_keys.push(markup_name);
					htkLog("Binding form element " + markup_name);
					_this.addBinding(markup_name, HtkBinding.prototype.create(element, _this, markup_name, [debug_message, markup_name]));
				}
			});
		}
	},
	addBinding : {
		value : function(attribute_key, binding) {
			var attribute_bindings = this.bindings[attribute_key];
			if (!attribute_bindings) {
				attribute_bindings = this.bindings[attribute_key] = [];
			}
			attribute_bindings.push(binding);
			return binding;
		}
	},
	toObject : {
		value : function() {
			var _this = this;
			var result = new Object();
			_.each(this.attribute_keys, function(key) {
				result[key] = _this[key];
			});
			return result;
		}
	}
});

