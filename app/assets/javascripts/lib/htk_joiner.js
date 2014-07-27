HtkJoiner = function() {
	this.done_when_zero = 0;
	this.done = null;
}

// HtkJoiner.prototype = Object.create(null);

HtkJoiner.prototype.add = function() {
	this.done_when_zero++;
}

HtkJoiner.prototype.remove = function() {
	--this.done_when_zero;
	this.maybeJoin();
}

HtkJoiner.prototype.maybeJoin = function() {
	if ((this.done_when_zero == 0) && this.done) {
		this.done();
	}
}

HtkJoiner.prototype.join = function(done_callback) {
	this.done = done_callback;
	this.maybeJoin();
}
