function Deliverable(json, deliverable_users) {
	for (var property in json) {
    if (json.hasOwnProperty(property)) {
    	this[property] = json[property]
    }
	}
	this.hello = "world";
	var d = this;
	_.each(deliverable_users, function(du) {
		if (du.deliverable_id == d.id) {
			if (du.access == "owner") {
				d.owner = du.user;
			}
			if (du.responsible) {
				d.responsible = du.user;
			}
		}
	})
}

Deliverable.prototype.owner = null;
Deliverable.prototype.responsible = null;
Deliverable.prototype.hello = null;
Deliverable.prototype.isSelected = null;