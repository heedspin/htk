function LxdOpportunitiesController() {
  HtkController.call(this);
}

LxdOpportunitiesController.prototype = Object.create(DeliverablesController.prototype);

LxdOpportunitiesController.prototype.getNewView = function(newContainer) {
  var newForm = $(HandlebarsTemplates["deliverables/lxd_opportunities/new"]({ deliverable_type : this.deliverableType }));
  this.setParentDeliverableOptions(newForm);
  newContainer.append(newForm.hide());
  return newForm;
}

