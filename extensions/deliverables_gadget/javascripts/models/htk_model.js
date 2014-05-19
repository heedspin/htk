function HtkModel(attributes) {
	this.id = null;
	this.changes = [];
	this.write_attributes(attributes);
}

HtkModel.prototype = Object.create(Object.prototype, {
	gadget_keys : {
		value : ["opensocial_owner_id", "from_address", "to_addresses", "cc_addresses", "date", "subject", "web_id"]
	},
	api_url : {
		value : function() {}
	},
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
	constructor : { value : HtkModel },
	build_without_changes : {
		value : function(attributes, results) {
			var new_object = new this.constructor(attributes, results);
			new_object.reset_changes();
			return new_object;
		}
	},
	reset_changes : { value : function() { this.changes = []; }},
	write_attribute : {
		value : function(key, value) {
			if ((typeof(this[key]) === "undefined") || (this[key] != value)) {
				this.changes.push({
					attribute : key,
					previous_value : this[key],
					new_value : value
				});
				this[key] = value;
			}
		}
	},
	write_attributes_by_obj : {
		value : function(obj) {
			for (var property in obj) {
	    	this.write_attribute(property, obj[property]);
		    // if (obj.hasOwnProperty(property)) {
		    // }
			}
		}
	},
	write_attributes : {
		value : function(thing) {
			if (thing instanceof Array) {
				_.each(thing, this.write_attributes_by_obj, this);
			} else {
				this.write_attributes_by_obj(thing);
			}
		}
	},
	save : {
		value : function(callbacks) {
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
	    var _this = this;
	    htkRequest("POST", this.api_url(), this.attributes(), function(obj) {
	    	_this.changes = [];
	    	_this.handle_callbacks(_this.update_single(obj), callbacks);
	    });
		}
	},
	update : {		
		value : function(callbacks) {
	    var _this = this;
	    htkRequest("PUT", this.api_url() + "/" + this.id, this.attributes(), function(obj) {
	    	_this.changes = [];
	    	_this.handle_callbacks(_this.update_single(obj), callbacks);
	    });
		}
	},
	extract_collection : {
		value : function(obj, results) {
			if (typeof(results) === "undefined") {
			  results = new Object( { obj : obj });
			}
			var _this = this;
			if (typeof(results[this.collection_key]) === "undefined") {
			  results[this.collection_key] = _.map(obj.data[this.collection_key], function(d) { return _this.build_without_changes(d, results); });
			}
		  return results;
		}
	},
	extract_single : {
		value : function(obj, results) {
			if (typeof(results) === "undefined") {
			  results = new Object( { obj : obj });
			}
			if (typeof(results[this.single_key]) === "undefined") {
			  results[this.single_key] = this.build_without_changes(obj.data[this.single_key], results);
			}
		  return results;
		}
	},
	update_single : {
		value : function(obj, results) {
			if (typeof(results) === "undefined") {
			  results = new Object( { obj : obj });
			}
			if (typeof(results[this.single_key]) === "undefined") {
			  results[this.single_key] = this;
			  this.write_attributes(obj.data[this.single_key]);
			  this.reset_changes();
			}
		  return results;
		}
	},
	handle_callbacks : {
		value : function(results, callbacks) {
		  if (results.obj.rc && results.obj.rc == 200) {
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
		}
	}
});

HtkModel.prototype.all = function(query_data, callbacks) {
	var _this = this;
	htkRequest("GET", this.api_url(), query_data, function(obj) {
		var results = _this.extract_collection(obj);
		_this.handle_callbacks(results, callbacks);
	});
}

HtkModel.prototype.find = function(id, callbacks) {
	var _this = this;
	htkRequest("GET", this.api_url() + "/" + id, null, function(obj) {
		var results = _this.extract_single(obj);
		_this.handle_callbacks(results, callbacks);
	});
}

HtkModel.prototype.destroy = function(callbacks) {
  htkRequest("DELETE", this.api_url() + "/" + this.id, null, function(obj) {
    var rc = "";
    if (obj.rc) rc = obj.rc;
    if (rc == 200) {
      htkLog("Delete relation succeeded");
	    if (callbacks.success && (typeof(callbacks.success) === "function")) callbacks.success(obj);
    } else {
      htkLog("Delete relation failed");
	    if (callbacks.error && (typeof(callbacks.error) === "function")) callbacks.error(obj);
    }
  });	
}
