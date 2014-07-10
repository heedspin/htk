function ProjectsController() {
  StandardDeliverablesController.call(this);
}

ProjectsController.prototype = Object.create(StandardDeliverablesController.prototype);

ProjectsController.prototype.getNewView = function(newContainer) {
	if (!this.newView) {
	  this.newView = $(HandlebarsTemplates["deliverables/projects/new"]({ deliverable_type : this.deliverableType }));
	  this.setParentDeliverableOptions(this.newView);
	  newContainer.append(this.newView.hide());
	  newContainer.on("click", "#htkv-new-project button#htk-action-cd", $.proxy(this.createEvent, this));
	  newContainer.on("change", ".parent-name-select", function(event) {
	    var select = $(this);
	    htkLog("parent changed to " + select.val());
	    var form = select.closest("form");
	    form.find("input[name=parent_name]").val("");
	    form.find("input[name=parent_id]").val(select.val());
	  });
	  this.populateAssignedUsersSelect(this.newView.find("form"), "# Owner(s)", "Select Owners");
	  // newContainer.bind('keypress', this.handleKeypress);		
	}
  return this.newView;
}

ProjectsController.prototype.populateAssignedUsersSelect = function(edit_form) {
	var _this = this;
	Deliverable.prototype.all(null, {
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
