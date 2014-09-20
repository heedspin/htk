function DashboardQuery(attributes) {
  HtkModel.call(this, attributes);
}
DashboardQuery.prototype = Object.create(HtkModel.prototype, {
  attribute_keys : { value : ["creator_id", "responsible_user_id"] }
});

function DashboardController(config) {
  HtkController.call(this, DashboardController.prototype.instance);
  this.container_id = config.container;
  this.container = $(config.container);
  this.query = new DashboardQuery(config.query);
  this.deliverables = null;
  this.refreshTimer = null;
  this.delayTimer = null;
  var _this = this;
  var delay_refresh = function(event) {
    if (_this.refreshTimer) {
      clearInterval(_this.refreshTimer);
      _this.refreshTimer = null;
    }
    if (_this.delayTimer)
      clearTimeout(_this.delayTimer);
    _this.delayTimer = setTimeout(function() { _this.scheduleRefresh(); }, 5000)
  };
  this.container.mousemove(delay_refresh); //.keydown(function() { htkLog("keydown"); delay_refresh() });
  this.container.on("click", ".completion", $.proxy(this.handleCreateCompletionComment, this));
}

DashboardController.prototype = Object.create(HtkController.prototype);

DashboardController.prototype.handleCreateCompletionComment = function(event) {
  var row = $(event.target).closest("tr");
  var deliverable = Deliverable.prototype.find_cached(row.data("id"));
  htkLog("Quick Complete for Deliverable", deliverable.id);

  var comment = new DeliverableComment({ deliverable_id: deliverable.id });
  if (deliverable.isCompleted()) {
    comment.comment_type_id = DeliverableCommentType.prototype.incomplete;
  } else {
    comment.comment_type_id = DeliverableCommentType.prototype.complete;
  }
  comment.save({
    success : function() {
      htkLog("Saved comment", comment);
    }
  })
}

DashboardController.prototype.loadController = function() {
  var _this = this;
  // if (this.deliverables.length > 0) {
  //   this.query.set("created_after", _this.deliverables[0].id);
  // }
  var request = this.query.toObject();
  Deliverable.prototype.all(request, {
    success : function(results) {
      if (results.deliverables && (results.deliverables.length > 0)) {
        // htkLog("Dashboard " + _this.container_id + " query:", request);
        var table = null;
        var new_deliverables = _.sortBy(results.deliverables, function(d) { return d.created_at } );
        if (_this.deliverables) {
          table = _this.container.find("table");
        } else {
          // htkLog("Loaded " + new_deliverables.length + " " + _this.container_id + " deliverables");
          table = $(HandlebarsTemplates['deliverables/table']());
          _this.container.append(table);
        }
        table_body = table.find("tbody");
        table_body.empty();
        _this.deliverables = [];
        _.each(new_deliverables, function(d) {
          _this.deliverables.unshift(d);
          var row = $(HandlebarsTemplates['deliverables/row']({ 
            deliverable: d, 
            project: d.getProject(), 
            company: d.getCompany()
          }));
          table_body.prepend(row);
        });
      }
      if (!_this.refreshTimer)
        _this.scheduleRefresh();  
    }
  });  
}

DashboardController.prototype.scheduleRefresh = function() {
  var _this = this;
  this.refreshTimer = setInterval($.proxy(_this.loadController, _this), 5000);
}