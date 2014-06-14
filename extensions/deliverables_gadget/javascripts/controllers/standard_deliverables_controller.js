function StandardDeliverablesController(router) {
  DeliverablesController.call(this, router);
  this.editViews = new Object();
  this.newView = null;
}

StandardDeliverablesController.prototype = Object.create(DeliverablesController.prototype, {
	template_directory : { value : "deliverables" }	
});

StandardDeliverablesController.prototype.getNewForm = function(newContainer) {
	if (!this.newView) {
	  this.newView = $(HandlebarsTemplates["deliverables/new"]({ deliverable_type : this.deliverableType }));
	  this.setParentDeliverableOptions(this.newView);
	  newContainer.append(this.newView.hide());
	  newContainer.on("click", "button#htk-action-cd", $.proxy(this.createEvent, this));
	  newContainer.on("change", ".parent-name-select", function(event) {
	    var select = $(this);
	    htkLog("parent changed to " + select.val());
	    var form = select.closest("form");
	    form.find("input[name=parent_name]").val("");
	    form.find("input[name=parent_id]").val(select.val());
	  });
	  // newContainer.bind('keypress', this.handleKeypress);		
	}
  return this.newView;
}

StandardDeliverablesController.prototype.getEditView = function(container) {
	var editView = this.editViews[this.deliverable.id];
	if (!editView) {
	  editView = $(HandlebarsTemplates['deliverables/edit'](this));
	  container.append(editView.hide());
	  editView.find("form button").click($.proxy(this.updateOrDeleteEvent, this));
	  // Toggle Save / Delete button.
	  editView.find("form input.htk-action-delete").click(function() {
	    var save_button = $(this).closest("form").find("button");
	    if ($(this).is(":checked")) {
	      save_button.html("Delete");
	    } else {
	      save_button.html("Save");     
	    }
	  });
	  // editView.bind('keypress', this.handleKeypress);

	  var edit_form = editView.find("form");
	  edit_form.resetForm();
	  edit_form.find("button").html("Save");
	  edit_form.attr("data-id", this.deliverable.id);
	  edit_form.find("input[name=title]").val(this.deliverable.title);
	  edit_form.find("textarea[name=description]").val(this.deliverable.description);
	  editView.find("input[name=title]").focus();
	  var _this = this;
	  User.prototype.all(null, {
	  	success : function(results) {
	  		var assigned = new Object();
	  		_.each(_this.deliverable.responsible_users, function(du) { assigned[du.user_id] = true; });
	      var options = $(HandlebarsTemplates['users/options']({assigned: assigned,  users: results.users}));
	      var select = edit_form.find("select[name=assigned_users]");
	      select.empty().append(options);
			  select.multiselect({
					selectedText: "# Assigned",
					noneSelectedText: "Assign Users"
				});//.multiselectfilter();
	  	}
	  })
	}
  return editView;
}

StandardDeliverablesController.prototype.createEvent = function(event) {
  var _this = this;
  var form = $(event.target).closest("form");
  if (form.find("input[name=title]").val()) {
    var matches = htkGetContentMatches().concat(form.formToNameValues());
    var deliverable_type = new Object({ config_id : $("#deliverable-type-select").val() });
    matches.push(deliverable_type);
    var parent_id = _.find(matches, function(nv) { return nv.parent_id });
    if (parent_id) parent_id = parent_id.parent_id;
    htkLog("createDeliverable: ", matches);
    var deliverable = new Deliverable(matches);
    deliverable.save({
      success : function(results) {
			  htkLog("Created new deliverable: ", results.obj.data);
        _this.deliverableTreeController.deliverableCreated(parent_id, results.deliverable);
      }, 
      error : function(results) {
        _this.setStatusMsg("Create deliverable failed.");
        // adjust_window_height();
        htkLog("Create deliverable response: ", results.obj);
      }
    });
  } else {
    htkLog("DeliverablesController.createEvent: no title");
  }
}