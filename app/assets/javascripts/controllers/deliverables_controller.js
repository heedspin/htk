function DeliverablesController() {
  HtkController.call(this, DeliverablesRouter.prototype.instance);
  this.deliverableType = null;
  this.deliverable = null;
  this.deliverableTreeController = this.router.deliverableTreeController;
  this.showViews = new Object();
}

DeliverablesController.prototype = Object.create(HtkController.prototype, {
	synchronize_assigned_users : {
		value : function(new_assigned_users) {
			var _this = this;
			var objects = [];
			if (_this.deliverable) {
				objects = _.map(_this.deliverable.permissions, function(du) { return { id : du.user_id, deliverable_user : du } });
			}
      ArraySynchronizer.prototype.synchronize(objects, new_assigned_users,
      	{
      		added : function(id, donebacks) {
      			htkLog("Permission: added " + id);
      			var new_du = new Permission({deliverable_id: _this.deliverable.id, 
      				user_id: id, 
      				responsible: true, 
      				access_id: Permission.prototype.edit_access_id});
      			new_du.save(donebacks);
      			return new_du;
      		},
      		removed : function(object, donebacks) {	
      			htkLog("Permission: removed " + object.id);
      			object.permission.write_attribute('responsible', false);
      			object.permission.save(donebacks);
      		},
      		done : function(permissions) {
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
	getShowView : {
		value : function(container) {
			var show_view = $(HandlebarsTemplates['deliverables/show']({ 
		  	current_user: this.router.currentUser, 
		  	deliverable: this.deliverable, 
		  	parent: this.deliverable.getParent()
		  }));
			container.append(show_view);
			var comments_container = show_view.find("div.comments");
			if (comments_container.length > 0) {
				this.deliverable.bindComments(this.router, comments_container);
			}
			var companies_controller = CompaniesController.prototype.getController(this.deliverable);
			companies_controller.showCompany(show_view.find(".htk-company-placeholder"));
			return show_view;
		},
	},
	showDeliverable : {
		value : function(container, update) {
			var show_view = this.showViews[this.deliverable.id];
			if (show_view) {
				if (update) {
					show_view.remove();
					show_view = this.getShowView(container);
				  this.showViews[this.deliverable.id] = show_view;
				} else {
					show_view.show();					
				}
			} else {
				show_view = this.getShowView(container);
			  this.showViews[this.deliverable.id] = show_view;
			}
		}	 
	},
	populateAssignedUsersSelect : {
		value : function(edit_form, selectedText, noneSelectedText) {
			if (!selectedText)
				selectedText = "# Assigned";
			if (!noneSelectedText)
				noneSelectedText = "Assign Users";
		  var _this = this;
		  User.prototype.all(null, {
		  	success : function(results) {
		  		var assigned = new Object();
		  		if (_this.deliverable) {
			  		_.each(_this.deliverable.responsible_users, function(du) { assigned[du.user_id] = true; });		  			
		  		}
		      var options = $(HandlebarsTemplates['users/options']({assigned: assigned,  users: results.users}));
		      var select = edit_form.find("select[name=assigned_users]");
		      select.empty().append(options);
				  select.multiselect({
						selectedText: selectedText,
						noneSelectedText: noneSelectedText
					});//.multiselectfilter();
		  	}
		  });
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

