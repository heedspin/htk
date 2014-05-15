function AssociateDeliverableController(router) {
  HtkController.call(this, router);
  this.deliverableTree = router.deliverablesController.deliverableTree;
  $("#htk-col2").on("click", ".htk-disassociate", $.proxy(this.showDisassociateEvent, this));
  $("#htk-dcontainer").on("click", ".htka-fd", $.proxy(this.showAssociateEvent, this));
  this.associateView = null;
  this.disassociateView = null;
}
AssociateDeliverableController.prototype = Object.create(HtkController.prototype);

AssociateDeliverableController.prototype.associateEvent = function(event) {
  var _this = this;
  var view = this.getAssociateView();
  var form = view.find("form");
  var deliverable_id = form.find("input[name=deliverable_id]").val();
  if (deliverable_id) {
    htkLog("associateDeliverable: " + deliverable_id);
    Deliverable.prototype.find(deliverable_id, {
      success : function(results) {
        _this.deliverableTree.createNode(null, results.deliverable, {
          success : function() {
            _this.router.deliverablesController.showDeliverable(results.deliverable);
          }
        });
      }
    });
  }
}

AssociateDeliverableController.prototype.getAssociateView = function() {
  if (!this.associateView) {
    this.associateView = $(HandlebarsTemplates['associate_deliverable/associate'](this));
    $("#htk-col2").append(this.associateView);
    this.associateView.find("button").click($.proxy(this.associateEvent, this));
    this.associateView.find("input[name='deliverable_name']").autocomplete({
      source: function(request, response) {
        htkRequest("GET", "/api/v1/deliverables?term=" + request.term, null, function(obj) {
          if (obj.errors.length > 0) {
            _this.statusMsg.empty().append("Error").show();
            htkLog("Error response: " + JSON.stringify(obj));
          } else {
            htkLog("deliverables autocomplete: " + JSON.stringify(obj.data));
            response(obj.data);
          }    
        });
      },
      select: function(event, ui) { 
        var input = $(this);
        input.val(ui.item.label); 
        var form = input.closest("form");
        htkLog("deliverable selected: " + ui.item.label + " - " + ui.item.value);
        form.find(".parent-name-select").val("");
        form.find("input[name=deliverable_id]").val(ui.item.value);
        return false; 
      }
    });
    this.associateView.find("#deliverable-name-select").change(function(event) {
      htkLog("associate deliverable changed to " + $(this).val());
      var select = $(this);
      var form = select.closest("form");
      form.find("input[name=deliverable_name]").val("");
      form.find("input[name=deliverable_id]").val(select.val());
    });
  }
  return this.associateView;
}

AssociateDeliverableController.prototype.getDisassociateView = function() {
  if (!this.disassociateView) {
    this.disassociateView = $(HandlebarsTemplates['associate_deliverable/disassociate'](this));
    $("#htk-col3").append(this.disassociateView);
    var _this = this;
    $("#htk-col3").on("click", "#htkv-disassociate button", function(e) {
      if ($(this).text() == "Cancel") {
        _this.cancelEvent(e);
      } else {
        _this.disassociateEvent(e);
      }
    });
  }
  return this.disassociateView;
}

AssociateDeliverableController.prototype.showAssociateEvent = function(e) {
  $("#htk-col2").children().hide();
  var view = this.getAssociateView();
  view.find("input[name=deliverable_id]").val(deliverable.id);
  var form = view.find("form");
  Deliverable.prototype.recent({ exclude : _.map(this.deliverableTree.deliverables, function(d) { return d.id; }) }, {
    success : function(results) {
      htkLog("deliverables recent: " + JSON.stringify(results.deliverables));
      var options = $(HandlebarsTemplates['deliverables/options']({placeholder : "Choose Recent Deliverable", deliverables: results.deliverables}));
      form.find("#deliverable-name-select").empty().append(options);
    },
    error : function(results) {
      _this.setStatusMsg("Error");
      htkLog("Error response: " + JSON.stringify(results.obj));
    }
  });
  view.show();
}

AssociateDeliverableController.prototype.showDisassociateEvent = function(e) {
  $("#htk-col3").children().hide();
  var deliverable = this.deliverableTree.getDeliverable($(e.target).closest(".htk-show").attr("data-id"));
  var view = this.getDisassociateView(); // $("#htkv-disassociate");
  view.find("input[name=deliverable_id]").val(deliverable.id);
  view.show();
}

AssociateDeliverableController.prototype.cancelEvent = function(e) {
  htkLog("Cancel Disassociate");
  this.getDisassociateView().hide();
}

AssociateDeliverableController.prototype.disassociateEvent = function(e) {
  $("#htkv-disassociate").hide();
  htkLog("Do Disassociate");
  var view = this.getDisassociateView();
  var deliverable_id = view.find("input[name=deliverable_id]").val();
  this.router.deliverablesController.removeDeliverable(deliverable_id, true);
  this.router.deliverablesController.showDeliverable();
}