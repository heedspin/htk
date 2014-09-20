function HtkObjectCache() {}

HtkObjectCache.prototype.types = new Object();	

HtkObjectCache.prototype.get = function(key, id) {
	var type_cache = this.types[key];
	if (type_cache) {
		var result = type_cache[id];
		// if (result) {
		// 	htkLog("HtkObjectCache(" + key + ") HIT");
		// }
		return result;
	} else {
		return null;
	}
};

HtkObjectCache.prototype.clear = function(key, id) {
	var type_cache = this.types[key];
	if (type_cache) {
		var value = type_cache[id];
		type_cache[id] = null;
		return value;
	} else {
		return null;
	}
};

HtkObjectCache.prototype.set = function(key, object) {
	if (!key)
		throw "HtkObjectCache.set called with null key";
	if (!object)
		throw "HtkObjectCache.set called for key " + key + " with null object";
	var type_cache = this.types[key];
	if (!type_cache) {
		type_cache = new Object();
		this.types[key] = type_cache;
	}
	type_cache[object.id] = object;
};

HtkObjectCache.prototype.all = function(key, query) {
	var result = [];
	var type_cache = this.types[key];
	if (type_cache) {
		for(var object_id in type_cache) {
			var object = type_cache[object_id];
			if (!object) {
				throw "HtkObjectCache Corrupt!";
			}
			var object_matches = true;
			for (var attribute in query) {
				var test_value = query[attribute];
				if (object[attribute] != test_value) {
					object_matches = false;
					break;
				}
			}
			if (object_matches) {
				result.push(object);
			}
		}
	}	
	return result;
}