function DisassociateDeliverableController(router) {
  HtkController.call(this, router);
  this.deliverableTree = router.deliverablesController.deliverableTree;
  $("#htk-col2").on("click", ".htk-disassociate", $.proxy(this.showDisassociateEvent, this));
  var _this = this;
  $("#htk-col3").on("click", "#htkv-disassociate button", function(e) {
    if ($(this).text() == "Cancel") {
      _this.cancelEvent(e);
    } else {
      _this.disassociateEvent(e);
    }
  });
}
DisassociateDeliverableController.prototype = Object.create(HtkController.prototype);

DisassociateDeliverableController.prototype.showDisassociateEvent = function(e) {
  $("#htk-col3").children().hide();
  var deliverable = this.deliverableTree.getDeliverable($(e.target).closest(".htk-show").attr("data-id"));
  var view = $("#htkv-disassociate");
  view.find("input[name=deliverable_id]").val(deliverable.id);
  view.show();
}

DisassociateDeliverableController.prototype.cancelEvent = function(e) {
  htkLog("Cancel Disassociate");
  $("#htkv-disassociate").hide();
}

DisassociateDeliverableController.prototype.disassociateEvent = function(e) {
  $("#htkv-disassociate").hide();
  var _this = this;
  htkLog("Do Disassociate");
  var view = $("#htkv-disassociate");
  var deliverable = this.deliverableTree.getDeliverable(view.find("input[name=deliverable_id]").val());
  this.router.getCurrentEmail({
    success : function(email) {
      ThreadDeliverable.prototype.destroy({
        deliverable_id : deliverable.id, 
        message_thread_id : email.message_thread_id
      }, {
        success : function(results) {
          _this.router.deliverablesController.removeDeliverable(deliverable.id);
          _this.router.deliverablesController.showDeliverable();
        }
      });
    }
  });
}