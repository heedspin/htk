function DeliverablesController(router) {
  HtkController.call(this, router);
  this.deliverableType = null;
  this.deliverable = null;
  this.deliverableTreeController = this.router.deliverableTreeController;
  this.showViews = new Object();
}

DeliverablesController.prototype = Object.create(HtkController.prototype, {
	template_directory : { value : "deliverables" },
	synchronize_assigned_users : {
		value : function(new_assigned_users) {
			var _this = this;
			var objects = _.map(_this.deliverable.responsible_users, function(du) { return { id : du.user_id, deliverable_user : du } });
      ArraySynchronizer.prototype.synchronize(objects, new_assigned_users,
      	{
      		added : function(id, donebacks) {
      			htkLog("DeliverableUser: added " + id);
      			var new_du = new DeliverableUser({deliverable_id: _this.deliverable.id, 
      				user_id: id, 
      				responsible: true, 
      				access_id: DeliverableUser.prototype.edit_access_id});
      			new_du.save(donebacks);
      			return new_du;
      		},
      		removed : function(object, donebacks) {	
      			htkLog("DeliverableUser: removed " + object.id);
      			object.deliverable_user.write_attribute('responsible', false);
      			object.deliverable_user.save(donebacks);
      		},
      		done : function(deliverable_users) {
			      htkLog("Putting deliverable succeeded");
			      _this.deliverable.registry_hook();
			      _this.deliverableTreeController.showDeliverable(_this.deliverable, true);		      			
      	}
    	});
		}
	},
	updateEvent : {
		value : function(form) {
		  var _this = this;
		  var nameValues = form.formToNameValues();
		  var new_assigned_users = form.find("select[name=assigned_users]").val();
		  htkLog("updating deliverable " + this.deliverable.id + " with " + JSON.stringify(nameValues));
		  // var deliverable = this.deliverableTree.getDeliverable(deliverable_id);
		  this.deliverable.write_attributes(nameValues);
		  if (this.deliverable.changed()) {
			  this.deliverable.save({
			    success : function(results) {		    	
			    	_this.synchronize_assigned_users(new_assigned_users);
			    }
			  });
		  } else {
	    	this.synchronize_assigned_users(new_assigned_users);
		  }
		}
	},
	deleteEvent : {
		value : function() {
		  var _this = this;
		  this.deliverable.destroy({
		  	success : function(results) {
		      htkLog("Delete deliverable succeeded");
		      _this.deliverableTreeController.removeDeliverable(_this.deliverable.id, false);
		      _this.deliverableTreeController.showDeliverable();		  		
		  	}
		  });
		  // htkRequest("DELETE", "/api/v1/deliverables/" + deliverable_id, null, function(obj) {
		  //   var rc = "";
		  //   if (obj.rc) rc = obj.rc;
		  //   if (rc == 200) {
		  //     htkLog("Delete deliverable succeeded");
		  //     _this.deliverableTreeController.removeDeliverable(_this.deliverable.id, false);
		  //     _this.deliverableTreeController.showDeliverable();
		  //   } else {
		  //     log("Deleting comment failed");
		  //   }
		  // });
		}
	},
	createShowView : {
		value : function() {
			var show_view = $(HandlebarsTemplates[this.template_directory + '/show']({ 
		  	current_user: this.router.currentUser, 
		  	deliverable: this.deliverable, 
		  	parent: this.deliverable.getParent() 
		  }));
		  this.showViews[this.deliverable.id] = show_view;
		  return show_view;
		},
	},
	showDeliverable : {
		value : function(container, update) {
			var show_view = this.showViews[this.deliverable.id];
			if (show_view) {
				if (update) {
					show_view.replaceWith(this.createShowView());
				}
			} else {
				show_view = this.createShowView();
				container.append(show_view);
			}
			show_view.show();
		}	 
	}
});

DeliverablesController.prototype.setDeliverable = function(deliverable_type, deliverable) {
	this.deliverableType = deliverable_type;
	this.deliverable = deliverable;
}

DeliverablesController.prototype.setParentDeliverableOptions = function(element) {
  var options = $(HandlebarsTemplates["deliverables/options"]({placeholder : "Select Parent", deliverables: this.router.deliverables()}));
  element.find(".parent-name-select").empty().append(options);
}

DeliverablesController.prototype.handleKeypress = function(e) {
  // Trap return key and click button.
  if(e.keyCode == 13) {
    $(this).find("button").click();
    e.preventDefault();
  }
}

DeliverablesController.prototype.updateOrDeleteEvent = function(event) {
  var button = $(event.target);
  var form = button.closest("form");
  // var deliverable_id = form.attr("data-id");
  if (button.html() == "Save") {
    this.updateEvent(form);
  } else {
    this.deleteEvent();
  }
}

