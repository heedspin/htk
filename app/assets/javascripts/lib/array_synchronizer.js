ArraySynchronizer = function() {}

// ArraySynchronizer.prototype = Object.create();

ArraySynchronizer.prototype.synchronize = function(objects, new_ids, callbacks) {
	var toremove = _.clone(objects);
	var toadd = [];
	var finals = [];

	var done_when_zero = 0;
	var call_done = function(results) {
		if (--done_when_zero <= 0) {
			callbacks.done(finals);
		}
	}
	donebacks = {	success : call_done, error : call_done };
	_.each(new_ids, function(new_id) {
		var exists = _.find(toremove, function(o) { return o.id == new_id; });
		if (exists) {
			finals.push(exists);
			toremove = _.reject(toremove, function(o) { return o.id == new_id; });
		} else {
			toadd.push(new_id);
		}
	});
	done_when_zero = toremove.length + toadd.length;
	if (done_when_zero == 0) {
		callbacks.done(finals);
	} else {
		_.each(toremove, function(o) { callbacks.removed(o, donebacks)});
		_.each(toadd, function(id) { finals.push(callbacks.added(id, donebacks)) });		
	}
}