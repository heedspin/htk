function DeliverableTree(deliverablesController) {
  this.deliverablesController = deliverablesController;
  this.deliverables = null;
	this.relations = null;
  this.tree = null;
  // this.deliverableLiTemplate = Handlebars.compile("<%= insert_file('html/deliverable_li.html', :javascript_escape => true) %>");
}

DeliverableTree.prototype = Object.create(null);

// var data = [
//   {
//       label: 'node1',
//       children: [
//           { label: 'child1' },
//           { label: 'child2' }
//       ]
//   },
//   {
//       label: 'node2',
//       children: [
//           { label: 'child3' }
//       ]
//   }
// ];
DeliverableTree.prototype.getTreeData = function() {
  var _this = this;
  var has_parent = new Object();
  var all_children = new Object();
  _.each(this.relations, function(r) {
    has_parent[r.target_deliverable_id] = true;
    if (all_children[r.source_deliverable_id]) {
      all_children[r.source_deliverable_id].push(r.target_deliverable_id);
    } else {
      all_children[r.source_deliverable_id] = [ r.target_deliverable_id ];
    }
  });
  var result = [];
  _.each(this.deliverables, function(d) {
    if (!has_parent[d.id]) {
      var subtree = _this.getSubTreeData(all_children, d);
      result.push(subtree);
    }
  });
	return result;
}

DeliverableTree.prototype.getSubTreeData = function(all_children, deliverable) {
  var _this = this;
  var new_node = this.createNode(deliverable);
  var children = all_children[deliverable.id];
  if (children) {
    var children_data = [];
    _.each(children, function(child_id) {
      var child_deliverable = _this.getDeliverable(child_id);
      children_data.push(_this.getSubTreeData(all_children, child_deliverable));
    });
    new_node["children"] = children_data;
  }
  return new_node;
}

DeliverableTree.prototype.initializeTree = function() {
  var _this = this;
  this.tree = $('#dtree').tree({
    data: this.getTreeData(),
    dragAndDrop: true
  }).bind(
    'tree.select',
    function(event) {
      if (event.node) {
        // node was selected
        var node = event.node;
        var deliverable = event.node.deliverable;
        htkLog(deliverable.title + " " + deliverable.id + " selected");
        _this.deliverablesController.showDeliverable(deliverable);
    } else {
      // event.node is null
      // a node was deselected
      // e.previous_node contains the deselected node
    }
  }
);
  // var _this = this;
  // _.each(this.currentDeliverables, function (deliverable) {
  //   _this.addDeliverableLi(deliverable);
  // });  
  // $("#htk-dlist").on("click", ".htk-action-sd", function(event) {
  //   _this.showDeliverable(_this.getDeliverable($(event.target).closest("li").attr("data-id")));
  // });
}

DeliverableTree.prototype.selectDeliverable = function(deliverable_id) {
  var node = this.tree.tree('getNodeById', deliverable_id);
  this.tree.tree('selectNode', node);
  // $(".htk-d").each(function() {
  //   var li = $(this);
  //   if (li.attr("data-id") == deliverable.id) {
  //     li.addClass("selected");
  //   } else {
  //     li.removeClass("selected");
  //   }
  // });
}

DeliverableTree.prototype.addDeliverable = function(deliverable) {
  this.deliverables.push(deliverable);
  if (deliverable.parent_id) {
    var parent_node = this.tree.tree('getNodeById', deliverable.parent_id);    
    this.tree.tree('appendNode', this.createNode(deliverable), parent_node);
  }
  // _this.addDeliverableLi(deliverable);
  // DeliverablesController.prototype.addDeliverableLi = function(deliverable) {
  //   var list_item = $(this.deliverableLiTemplate({ deliverable: deliverable }));
  //   deliverable.listItem = list_item;
  //   list_item.insertBefore($("#htk-action-nd"));
  // }
}

DeliverableTree.prototype.createNode = function(deliverable) {
  var new_node = {
    label : deliverable.title,
    id : deliverable.id,
    deliverable : deliverable
  }
  return new_node;
}

DeliverableTree.prototype.deliverableChanged = function(deliverable) {
  // var list_item = $(this.deliverableLiTemplate({ deliverable: deliverable }));
  // deliverable.listItem.replaceWith(list_item);
  // deliverable.listItem = list_item;
}

DeliverableTree.prototype.associateRelations = function() {
  var _this = this;
  _.each(this.relations, function(r) {
    r.set_deliverables(_this.deliverables);
  })
  _.each(this.deliverables, function(d) {
    d.set_relations(_this.relations);
  })
}

DeliverableTree.prototype.removeDeliverable = function(deliverable_id) {
  for (var i=0; i < this.deliverables.length; i++) {
    var deliverable = this.deliverables[i];
    if (deliverable.id == deliverable_id) this.deliverables.splice(i,1)
  }
  var node = this.tree.tree('getNodeById', deliverable_id);    
  this.tree.tree('removeNode', node);
  // $("#htk-dlist").find("li[data-id=" + deliverable_id + "]").remove();
}

DeliverableTree.prototype.getDeliverable = function(deliverable_id) {
  var deliverable = _.find(this.deliverables, function(d) {
    return (d.id == deliverable_id);
  });
  if (deliverable) {
    htkLog("getDeliverable " + deliverable_id + " = " + deliverable.title);    
  } else {
    htkLog("getDeliverable no deliverable for " + deliverable_id);
  }
  return deliverable;
}
