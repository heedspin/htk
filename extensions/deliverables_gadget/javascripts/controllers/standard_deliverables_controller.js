function StandardDeliverablesController() {
  DeliverablesController.call(this);
  this.editViews = new Object();
  this.newView = null;
}

StandardDeliverablesController.prototype = Object.create(DeliverablesController.prototype);

StandardDeliverablesController.prototype.getNewView = function(newContainer) {
	if (!this.newView) {
	  this.newView = $(HandlebarsTemplates["deliverables/standard/new"]({ deliverable_type : this.deliverableType }));
	  this.setParentDeliverableOptions(this.newView);
	  newContainer.append(this.newView.hide());
	  newContainer.on("click", "#htkv-new-standard button#htk-action-cd", $.proxy(this.createEvent, this));
	  newContainer.on("change", ".parent-name-select", function(event) {
	    var select = $(this);
	    htkLog("parent changed to " + select.val());
	    var form = select.closest("form");
	    form.find("input[name=parent_name]").val("");
	    form.find("input[name=parent_id]").val(select.val());
	  });
	  this.populateAssignedUsersSelect(this.newView.find("form"));
	  // newContainer.bind('keypress', this.handleKeypress);		
	}
  return this.newView;
}

StandardDeliverablesController.prototype.getEditView = function(container) {
	var editView = this.editViews[this.deliverable.id];
	if (!editView) {
	  editView = $(HandlebarsTemplates['deliverables/standard/edit'](this));
	  container.append(editView.hide());
	  editView.find("form button").click($.proxy(this.updateOrDeleteEvent, this));
	  // Toggle Save / Delete button.
	  editView.find("form input.htk-action-delete").click(function() {
	    var save_button = $(this).closest("form").find("button#htk-action-sd");
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
	  this.populateAssignedUsersSelect(edit_form);
	}
  return editView;
}

StandardDeliverablesController.prototype.createEvent = function(event) {
  var _this = this;
  var form = $(event.target).closest("form");
  if (form.find("input[name=title]").val()) {
    var params = form.formToNameValues();
    params.push({ deliverable_type_id : $("#deliverable-type-select").val() });
    params.push({ email_id : this.router.currentEmail.id })
    var parent_id = _.find(params, function(nv) { return nv.parent_id });
    if (parent_id) parent_id = parent_id.parent_id;
    htkLog("createDeliverable: ", params);
    this.deliverable = new Deliverable(params);
    this.deliverable.save({
      success : function(results) {
			  htkLog("Created new deliverable: ", results.obj.data);
        _this.deliverableTreeController.addDeliverable(parent_id, results.deliverable, {
        	success : function(results) {
			    	_this.synchronize_assigned_users(form.find("select[name=assigned_users]").val());
        	}
        });
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