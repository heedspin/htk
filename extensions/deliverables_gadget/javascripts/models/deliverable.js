function Deliverable(json, deliverable_users) {
	this.update_attributes(json);
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
Deliverable.prototype.isSelected = null;

Deliverable.prototype.update_attribute = function(key, value) {
	this[key] = value;
	if (key == 'title') {
	  $("#htk-dlist").find("li[data-id=" + this.id + "] span.htk-title").html(this.title);
	}
}

Deliverable.prototype.update_attributes_by_obj = function(obj) {
	for (var property in obj) {
    if (obj.hasOwnProperty(property)) {
    	this.update_attribute(property, obj[property]);
    }
	}
}

Deliverable.prototype.update_attributes = function(thing) {
	if (thing instanceof Array) {
		_.each(thing, this.update_attributes_by_obj, this);
	} else {
		this.update_attributes_by_obj(thing);
	}
}
