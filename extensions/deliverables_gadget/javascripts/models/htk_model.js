function HtkModel(attributes) {
	this.id = null;
	this.update_attributes(attributes);
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
				if (value) {
					result[attribute_key] = value;
				}
			});
			return result;
		}
	},
	update_attribute : {
		value : function(key, value) {
			// htkLog("update_attribute " + key + " = " + value);
			this[key] = value;
		}
	},
	update_attributes_by_obj : {
		value : function(obj) {
			// htkLog("update_attributes_by_obj: " + JSON.stringify(obj));
			for (var property in obj) {
		    if (obj.hasOwnProperty(property)) {
		    	this.update_attribute(property, obj[property]);
		    }
			}
		}
	},
	update_attributes : {
		value : function(thing) {
			if (thing instanceof Array) {
				_.each(thing, this.update_attributes_by_obj, this);
			} else {
				this.update_attributes_by_obj(thing);
			}
		}
	},
	save : {
		value : function(callbacks) {
			if (!this.id) {
				this.create(callbacks);
			} else {
				this.update(callbacks);
			}
		}
	},
	saveRequest : {
		value : function(http_method, url, query_data, callbacks) {
			// htkLog("saveRequest request: " + http_method + " " + url + " " + JSON.stringify(query_data));
			var _self = this;
	    htkRequest(http_method, url, query_data, function(obj) {
	    	var results = _self.extract_single(obj);
	      if (obj.rc && obj.rc == 200) {
	      	// Should be done by extract_single: _self.update_attributes(obj[_self.single_key]);
	      	if (callbacks && callbacks.success && typeof(callbacks.success) === "function") {  
	      		callbacks.success(results);
					}
	      } else {
	      	if (callbacks && callbacks.error && typeof(callbacks.error) === "function") {  
	      		callbacks.error(results);
					}
	      }
	    });
	  }
	},
	create : {		
		value : function(callbacks) {
	    this.saveRequest("POST", this.api_url(), this.attributes(), callbacks);
		}
	},
	update : {
		value : function(callbacks) {	
	    this.saveRequest("PUT", this.api_url() + "/" + this.id, this.attributes(), callbacks);
		}
	},
	extract_collection : {
		value : function(obj) {
		  var results = new Object( { obj : obj });
		  results[this.collection_key] = obj.data[this.collection_key]
		  return results;
		}
	},
	extract_single : {
		value : function(obj) {
		  var results = new Object( { obj : obj });
		  results[this.single_key] = obj.data[this.single_key]
		  return results;
		}
	}
});

HtkModel.prototype.handle_callbacks = function(results, callbacks) {
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

HtkModel.prototype.all = function(query_data, callbacks) {
	var _self = this;
	htkRequest("GET", this.api_url(), query_data, function(obj) {
		var results = _self.extract_collection(obj);
		_self.handle_callbacks(results, callbacks);
	});
}

HtkModel.prototype.find = function(id, callbacks) {
	var _this = this;
	htkRequest("GET", this.api_url() + "/" + id, null, function(obj) {
		var results = _this.extract_single(obj);
		_this.handle_callbacks(results, callbacks);
	});
}