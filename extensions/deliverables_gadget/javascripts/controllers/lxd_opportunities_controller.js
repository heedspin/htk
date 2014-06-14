function LxdOpportunitiesController(router) {
  HtkController.call(this, router);
}

LxdOpportunitiesController.prototype = Object.create(DeliverablesController.prototype);

LxdOpportunitiesController.prototype.getNewForm = function(newContainer) {
  var newForm = $(HandlebarsTemplates["lxd_opportunities/new"]({ deliverable_type : this.deliverableType }));
  this.setParentDeliverableOptions(newForm);
  newContainer.append(newForm.hide());
  return newForm;
}

