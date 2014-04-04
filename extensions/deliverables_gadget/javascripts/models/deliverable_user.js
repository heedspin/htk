function DeliverableUser(json, users) {
	for (var property in json) {
    if (json.hasOwnProperty(property)) {
    	this[property] = json[property]
    }
	}
	var du = this;
	this.user = _.find(users, function(u) {
		if (u.id == du.user_id) return true;
	})
}

DeliverableUser.prototype.user = null;