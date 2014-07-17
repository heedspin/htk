function CompaniesController() {
  HtkController.call(this);
  this.company_relation = null;
}

CompaniesController.prototype = Object.create(HtkController.prototype);

CompaniesController.prototype.instance = null;
CompaniesController.prototype.getController = function(deliverable) {
  var controller = CompaniesController.prototype.instance;
  if (!controller) {
    controller = CompaniesController.prototype.instance = new CompaniesController;
    controller.setupEvents();
  }
  var company_relation = deliverable.company_relation;
  if (!company_relation) {
    company_relation = new DeliverableRelation({
      relation_type_id : DeliverableRelation.prototype.company_relation_type,
      target_deliverable_id: deliverable.id
    });
  }
  controller.company_relation = company_relation;
  return controller;
}

CompaniesController.prototype.showNewCompany = function(deliverable_id, container) {
  var newView = $(HandlebarsTemplates['companies/new']());
  container.replaceWith(newView);
}

CompaniesController.prototype.showCompany = function(targetContainer) {
  var view = $(HandlebarsTemplates['companies/show']({relation: this.company_relation}));
  targetContainer.replaceWith(view);
}

CompaniesController.prototype.setupEvents = function() {
  var _this = this;
  $("#htk-col2").on("click", ".htka-new-company", function(event) {
    var target = $(event.target);
    var container = target.closest("div.htk-company");
    var deliverable_id = target.data("deliverable-id");
    _this.showNewCompany(deliverable_id, container);
  });
  $("#htk-col2").on("click", ".htk-company .htk-create", function(event) {
    var target = $(event.target);
    var container = target.closest("div.htk-company");
    var deliverable_id = target.data("deliverable-id");
    CompaniesController.prototype.createCompany(container, deliverable_id)
  });
  $("#htk-col2").on("click", ".htk-company .htk-cancel", function(event) {
    var container = $(event.target).closest("div.htk-company");
    _this.showCompany(container);
  });
}

CompaniesController.prototype.createCompany = function(container, deliverable_id) {
  var _this = this;
  var form = container.find("form");
  if (form.find("input[name=title]").val()) {
    var params = form.formToNameValues();
    params.push({ deliverable_type_id : $("#deliverable-type-select").val() });
    params.push({ email_id : this.router.currentEmail.id })
    var parent_id = _.find(params, function(nv) { return nv.parent_id });
    if (parent_id) parent_id = parent_id.parent_id;
    htkLog("createCompany: ", params);
    this.deliverable = new Deliverable(params);
    this.deliverable.save({
      success : function(results) {
        htkLog("Created new company: ", results.obj.data);
        _this.deliverableTreeController.createRelation(parent_id, results.deliverable, {
          success : function(results) {
            _this.synchronize_assigned_users(form.find("select[name=assigned_users]").val());
          }
        });
      }, 
      error : function(results) {
        _this.setStatusMsg("Create company failed.");
        // adjust_window_height();
        htkLog("Create company response: ", results.obj);
      }
    });
  } else {
    htkLog("DeliverablesController.createEvent: no title");
  }
}