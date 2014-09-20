function DeliverableTreeController() {
  HtkController.call(this, DeliverablesRouter.prototype.instance);
  this.deliverableTree = new DeliverableTree(this);
  this.loadDeliverables();
  this.newView = null;
  this.editView = null;
  this.deliverableTypes = new Object();
  this.deliverableTypeControllers = new Object();
}

DeliverableTreeController.prototype = Object.create(HtkController.prototype);

DeliverableTreeController.prototype.loadDeliverables = function() {
  var _this = this;
  this.setStatusMsg("Loading Deliverables...");
  adjust_window_height();
  var query_data = htkGetContentMatches(["date_sent", "sender_email", "message_id"]);
  htkLog("Load Deliverables Matches: ", query_data);
  Deliverable.prototype.all(query_data, {
    success : function(results) {
      htkLog("Load Deliverables: " + JSON.stringify(results.obj.data));
      if (results.deliverables.length == 0) {
        _this.router.loadCurrentEmail({
          success : function(results) {
            _this.renderDeliverables();
            adjust_window_height();
          }
        });
      } else {
        _this.deliverableTree.setDeliverables(results.deliverables);
        _this.router.currentEmail = results.email;
        _this.renderDeliverables();
        adjust_window_height();
      }
    },
    error : function(results) {
      if (results.obj.rc && (results.obj.rc == "404")) {
        htkLog("Email not found");
        _this.setStatusMsg("Email not processed by server yet");
      } else if (results.obj.errors.length > 0) {
        _this.setStatusMsg("Error");
        htkLog("Error response: " + JSON.stringify(results.obj));
        adjust_window_height();
      }
    }
  })
}
DeliverableTreeController.prototype.removeDeliverable = function(deliverable_id, delete_association) {
  this.deliverableTree.removeDeliverable(deliverable_id, delete_association);
  $(".htk-show > div[data-id=" + deliverable_id + "]").remove();
}
DeliverableTreeController.prototype.renderDeliverables = function() {
  this.deliverableTree.initializeTree(this.router.currentEmail.message_thread_id);
  this.showDeliverable();
  this.setStatusMsg("EAT-" + this.router.currentEmail.email_account_thread_id + " T-" + this.router.currentEmail.message_thread_id + " M-" + this.router.currentEmail.message_id);
  $("#htk-dcontainer").on("click", ".htka-nd", $.proxy(this.newDeliverable, this));
  $("#htk-col2").on("click", ".htk-edit", $.proxy(this.editDeliverable, this));
}
DeliverableTreeController.prototype.editDeliverable = function(event) {
  var container = $("#htk-col2");
  container.children().hide(); 
  $("#htk-col3").children().hide();
  var deliverable = this.deliverableTree.getDeliverable($(event.target).closest(".htk-show").attr("data-id"));
  var controller = this.getController(deliverable);
  controller.getEditView(container).show();
  adjust_window_height();
};

DeliverableTreeController.prototype.showDeliverable = function(deliverable, update) {
  $("#htk-col3").children().hide();
  if (!deliverable) htkLog("showDeliverable called without deliverable.  Searching...");
  if (!deliverable) deliverable = _.find(this.deliverableTree.deliverables, function(d) { return !d.isCompleted(); });
  if (!deliverable && this.deliverableTree.deliverables) deliverable = this.deliverableTree.deliverables[0];

  var container = $("#htk-col2");
  container.children().hide();

  if (!deliverable) return;
  this.deliverableTree.selectDeliverable(deliverable.id);

  this.getController(deliverable).showDeliverable(container, update);
  if (update) {
    // TODO: convert to event model.
    this.deliverableTree.deliverableChanged(deliverable);
  }
  adjust_window_height();
}

DeliverableTreeController.prototype.getController = function(thing) {
  htkLog("DeliverableTreeController.getController: ", thing);
  var deliverable = null;
  var deliverable_type = null;
  if (thing instanceof Deliverable) {
    deliverable = thing;
    deliverable_type = thing.deliverable_type;
  } else if (thing instanceof DeliverableType) {
    deliverable_type = thing;
  } else if (typeof(thing) == "string") {
    deliverable_type = this.deliverableTypes[thing];
  }
  var controller = this.deliverableTypeControllers[deliverable_type.js_controller];
  if (!controller) {
    var newControllerProto = window[deliverable_type.js_controller];
    if (!newControllerProto) {
      htkLog("No controller prototype for " + deliverable_type.js_controller);
    } else {
      controller = new newControllerProto(this.router);
      this.deliverableTypeControllers[deliverable_type.js_controller] = controller;
    }
  }
  controller.setDeliverable(deliverable_type, deliverable);
  return controller;
}

DeliverableTreeController.prototype.getNewView = function(callbacks) {
  if (!this.newView) {
    this.newView = $(HandlebarsTemplates['deliverables/new_selection'](this));
    var newFormContainer = this.newView.find("div").first();
    $("#htk-col2").append(this.newView);
    var _this = this;
    DeliverableType.prototype.all(null, {
      success : function(results) {
        _.each(results.deliverable_types, function(dt) {
          _this.getController(dt);
          _this.deliverableTypes[dt.id] = dt;
        });
        var options = $(HandlebarsTemplates["deliverables/type_options"]({deliverable_types: results.deliverable_types}));
        _this.newView.find("#deliverable-type-select").empty().append(options).change(function(event) {
          newFormContainer.children().hide();
          var selected_val = $(this).val();
          if (selected_val == "associate") {
            _this.router.associateDeliverableController.getAssociateView(newFormContainer).show();
          } else {
            _this.getController($(this).val()).getNewView(newFormContainer).show();            
          }
        }).change();
        callbacks.success(_this.newView);
      }
    });
  } else {
    this.newView.find("form").resetForm();
    callbacks.success(this.newView);
  }
}

DeliverableTreeController.prototype.newDeliverable = function(event) {
  var _this = this;
  $("#htk-col2").children().hide(); $("#htk-col3").children().hide();
  this.getNewView({
    success : function(view) {
      view.show();
      adjust_window_height();      
    }
  });
}

DeliverableTreeController.prototype.createRelation = function(parent_id, deliverable, callbacks) {
  this.deliverableTree.createNode(this.router.currentEmail.message_id, parent_id, deliverable, callbacks);
}

DeliverableTreeController.prototype.getDeliverable = function(deliverable_id){
  return this.deliverableTree.getDeliverable(deliverable_id);
}