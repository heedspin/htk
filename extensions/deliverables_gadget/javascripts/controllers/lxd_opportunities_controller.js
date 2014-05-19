function LxdOpportunitiesController(router) {
  HtkController.call(this, router);
}

LxdOpportunitiesController.prototype = Object.create(HtkController.prototype);

LxdOpportunitiesController.prototype.createNewForm = function(newView, deliverable_type) {
  var newContainer = newView.find("div").first();
  var newForm = $(HandlebarsTemplates["lxd_opportunities/new"]({ deliverable_type : deliverable_type }));
  newContainer.append(newForm.hide());
}
