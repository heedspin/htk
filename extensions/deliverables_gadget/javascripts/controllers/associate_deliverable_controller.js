function AssociateDeliverableController(router) {
  HtkController.call(this, router);
  this.deliverableTree = router.deliverablesController.deliverableTree;
  $("#htk-col2").on("click", ".htk-disassociate", $.proxy(this.showDisassociateEvent, this));
  $("form#find-deliverable > button").click($.proxy(this.associateEvent, this));
  var _this = this;
  $("#htk-col3").on("click", "#htkv-disassociate button", function(e) {
    if ($(this).text() == "Cancel") {
      _this.cancelEvent(e);
    } else {
      _this.disassociateEvent(e);
    }
  });
}
AssociateDeliverableController.prototype = Object.create(HtkController.prototype);

AssociateDeliverableController.prototype.associateEvent = function(event) {
  var _this = this;
  var form = $(event.target).parent();
  var deliverable_id = form.find("input[name=deliverable_id]").val();
  if (deliverable_id) {
    var matches = htkGetContentMatches(["date_sent", "sender_email", "message_id"]);
    htkLog("associateDeliverable: " + deliverable_id + " to " + JSON.stringify(matches));
    this.router.getCurrentEmail({
      success : function(email) {
        var thread_deliverable = new ThreadDeliverable({ 
          deliverable_id : deliverable_id, 
          message_thread_id : email.message_thread_id
        });
        thread_deliverable.save({
          success : function(results) {
            htkLog("Association succeeded");
            Deliverable.prototype.find(deliverable_id, {
              success : function(results) {
                _this.deliverableTree.addDeliverable(results.deliverable);
                _this.router.deliverablesController.showDeliverable(results.deliverable);
              }
            });
          }
        });
      },
      error : function(obj) {
        htkLog("Failed to get current email.  Must not be loaded yet...");
      }
    });
  }
}

AssociateDeliverableController.prototype.showDisassociateEvent = function(e) {
  $("#htk-col3").children().hide();
  var deliverable = this.deliverableTree.getDeliverable($(e.target).closest(".htk-show").attr("data-id"));
  var view = $("#htkv-disassociate");
  view.find("input[name=deliverable_id]").val(deliverable.id);
  view.show();
}

AssociateDeliverableController.prototype.cancelEvent = function(e) {
  htkLog("Cancel Disassociate");
  $("#htkv-disassociate").hide();
}

AssociateDeliverableController.prototype.disassociateEvent = function(e) {
  $("#htkv-disassociate").hide();
  htkLog("Do Disassociate");
  var view = $("#htkv-disassociate");
  var deliverable_id = view.find("input[name=deliverable_id]").val();
  this.router.deliverablesController.removeDeliverable(deliverable_id);
  this.router.deliverablesController.showDeliverable();
}