function DeliverableTree(deliverableTreeController) {
  this.deliverableTreeController = deliverableTreeController;
  this.deliverables = [];
  this.tree = null;
  this.message_thread_id = null;
}

DeliverableTree.prototype = Object.create(null);

DeliverableTree.prototype.setDeliverables = function(deliverables) {
  var _this = this;
  this.deliverables = _.select(deliverables, function(d) { return d.getParentRelation(); });
  _.each(this.deliverables, function(d) { d.tree = _this; });
}

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
  var all_children = new Object();
  var all_parents = new Array();
  _.each(this.deliverables, function(d) {
    if (!d.getParentRelation().source_deliverable_id) {
      all_parents.push(d);
    } else {
      if (all_children[d.getParentRelation().source_deliverable_id]) {
        all_children[d.getParentRelation().source_deliverable_id].push(d);
      } else {
        all_children[d.getParentRelation().source_deliverable_id] = [ d ];
      }
    }
  });
  var sorted_parents = this.sortSiblings(all_parents);
  // htkLog("DeliverableTree sorted parents = " + JSON.stringify(_.pluck(sorted_parents, "id")));
  var result = [];
  _.each(sorted_parents, function(d) {
    result.push(_this.getSubTreeData(all_children, d));
  });
	return result;
}

DeliverableTree.prototype.getSubTreeData = function(all_children, deliverable) {
  var children = all_children[deliverable.id];
  // htkLog("DeliverableTree.getSubTreeData " + deliverable.id + " children = " + _.pluck(children, "id"));  
  var _this = this;
  var new_node = this.newNode(deliverable);
  children = this.sortSiblings(children);
  if (children) {
    var children_data = [];
    _.each(children, function(child_deliverable) {
      children_data.push(_this.getSubTreeData(all_children, child_deliverable));
    });
    new_node["children"] = children_data;
  }
  return new_node;
}

DeliverableTree.prototype.sortSiblings = function(unsorted, sorted, remainingAttempts) {
  if (typeof(unsorted) === "undefined") {
    return null;
  } else if (typeof(remainingAttempts) == "undefined") {
    remainingAttempts = 30
  } else {
    if (--remainingAttempts <= 0) {
      // htkLog("Max attempts reached");
      return unsorted;
    }
  }
  if (typeof(sorted) === "undefined") {
    sorted = new Array();
    // htkLog("Created sorted with unsorted = " + JSON.stringify(_.pluck(unsorted, "id")));
  }
  if (unsorted.length <= 1) {
    if (unsorted.length == 1) sorted.push(unsorted[0]);
    // htkLog("Sorting done.  Sorted = " + JSON.stringify(_.pluck(sorted, "id")));
    return sorted;
  } else {
    // htkLog("DeliverableTree.sortSiblings: Unsorted", unsorted, "\nsorted", sorted);
    unsorted = _.reject(unsorted, function(ud) { 
      if (!ud.getParentRelation().previous_sibling_id) {
        sorted.push(ud);
        // htkLog("DeliverableTree.sortSiblings: Found first node ", ud);
        return true;
      } else {
        var nextd = _.find(sorted, function(sd) { return ud.getParentRelation().previous_sibling_id == sd.id; });
        if (nextd) {
          // htkLog("DeliverableTree.sortSiblings: Added next", ud);
          sorted.push(ud);
          return true;
        } else {
          return false;
        }
      } 
    });    
    return DeliverableTree.prototype.sortSiblings(unsorted, sorted, remainingAttempts);
  }
}

DeliverableTree.prototype.newNode = function(deliverable) {
  var new_node = {
    label : deliverable.title,
    id : deliverable.id,
    deliverable : deliverable
  }
  if (deliverable.getParentRelation()) {
    new_node['parent_relation'] = deliverable.getParentRelation();
  }
  return new_node;
}

DeliverableTree.prototype.deliverableChanged = function(deliverable) {
  var node = this.tree.tree('getNodeById', deliverable.id);
  this.tree.tree('updateNode', node, deliverable.title);
}

DeliverableTree.prototype.initializeTree = function(message_thread_id) {
  this.message_thread_id = message_thread_id
  var _this = this;
  this.tree = $('#dtree').tree({
    data: this.getTreeData(),
    dragAndDrop: true,
    onCreateLi: function(node, $li) {
      var deliverable = node.deliverable;
      var title = $li.find('.jqtree-title')
      if (!deliverable.isCompleted()) {
        title.wrap('<strong></strong>');
        title = title.parent();
      }
      if (deliverable.responsible_users.length > 0) {
        var first_names = _.map(deliverable.responsible_users, function(du) { return du.user.first_name; } );
        title.after("<span class=\"assigned\"> - " + first_names.join(", ") + "</span>");
      }
    }
  }).bind('tree.select',
    function(event) {
      if (event.node) {
        // node was selected
        var deliverable = event.node.deliverable;
        htkLog(deliverable.title + " " + deliverable.id + " selected");
        _this.deliverableTreeController.showDeliverable(deliverable);
      } else {
        // var deliverable = event.previous_node.deliverable;
        // htkLog(deliverable.title + " " + deliverable.id + " deselected");
      }
    }
  ).bind(
    'tree.move',
    function(event) {
      event.preventDefault();
      event.move_info.do_move();
      _this.writeTree();
      // _this.handleMove(event.move_info.moved_node, event.move_info.target_node, event.move_info.position, event.move_info.previous_parent);
    }
  ).bind( 
    'tree.click',
    function(event) { // Prevent deselect.  Implement re-select.
      if (_this.tree.tree('isNodeSelected', event.node)) {
        var deliverable = event.node.deliverable;
        _this.deliverableTreeController.showDeliverable(deliverable);        
        event.preventDefault();
      }
    }
);
}

DeliverableTree.prototype.writeTree = function(node) {
  var _this = this;
  if (typeof(node) === "undefined") {
    node = this.tree.tree("getTree");
  }
  if (node.deliverable) {
    var relation = node.deliverable.getParentRelation();
    if (node.parent) {
      if (node.parent.deliverable) {
        relation.write_attribute('source_deliverable_id', node.parent.id);
      } else {
        relation.write_attribute('source_deliverable_id', null);
      }
      var previous_node = node.getPreviousSibling();
      if (previous_node) {
        relation.write_attribute('previous_sibling_id', previous_node.id); 
      } else {
        relation.write_attribute('previous_sibling_id',null);
      }
      relation.save();
    }
  }
  _.each(node.children, function(child) {
    _this.writeTree(child);
  });
}

DeliverableTree.prototype.selectDeliverable = function(deliverable_id) {
  var node = this.tree.tree('getNodeById', deliverable_id);
  this.tree.tree('selectNode', node);
}

DeliverableTree.prototype.addRelation = function(relation) {
  var deliverable = relation.getTargetDeliverable();
  deliverable.tree = this;
  var new_node = this.newNode(deliverable);
  var last_parent = _.last(this.tree.tree('getTree').children);
  if (!last_parent) {
    this.tree.tree('appendNode', new_node);
    htkLog("Tree: added first: " + deliverable.title);
  } else if (relation.source_deliverable_id) {
    var parent_node = this.tree.tree('getNodeById', relation.source_deliverable_id);
    this.tree.tree('appendNode', new_node, parent_node);
    htkLog("Tree: added to parent: " + parent_node.deliverable.title + " => " + deliverable.title);
  } else {
    this.tree.tree('addNodeAfter', new_node, last_parent);
    htkLog("Tree: added top level after: " + last_parent.deliverable.title + ", " + deliverable.title);
  }
  htkLog("Tree: added node " + JSON.stringify(new_node.label));
  this.deliverables.push(deliverable);
  // Reload to get sibling data.
  new_node = this.tree.tree('getNodeById', new_node.id);
  return new_node;
}

DeliverableTree.prototype.createNode = function(message_id, parent_id, deliverable, callbacks) {
  // htkLog("DeliverableTree.createNode with deliverable " + deliverable.id);
  var relation = new DeliverableRelation({
    source_deliverable_id : parent_id,
    target_deliverable_id : deliverable.id,
    relation_type_id : DeliverableRelation.prototype.parent_relation_type,
    message_thread_id : this.message_thread_id,
    message_id : message_id
  });
  var new_node = this.addRelation(relation);
  var previous_node = new_node.getPreviousSibling();    
  if (previous_node) {
    relation.write_attribute('previous_sibling_id', previous_node.id);
  }
  var _this = this;
  relation.save({
    success : function(results) {
      _.each(results.deliverable_relations, function(r) { return _this.addRelation(r) });
      callbacks["success"](results);
    },
    error : callbacks['error']
  });
}

DeliverableTree.prototype.removeDeliverable = function(deliverable_id, delete_association) {
  var node = this.tree.tree('getNodeById', deliverable_id);
  if (!node) return;
  this.deliverables = _.reject(this.deliverables, function(d) { return d.id == deliverable_id });
  var node = this.tree.tree('getNodeById', deliverable_id);
  var _this = this;
  this.tree.tree('removeNode', node);
  if (delete_association) {
    node.deliverable.getParentRelation().destroy({
      success : function() {
        _this.writeTree();
      }
    });
  } else {
    _this.writeTree();
  }
}

DeliverableTree.prototype.getDeliverable = function(deliverable_id) {
  var deliverable = _.find(this.deliverables, function(d) {
    return (d.id == deliverable_id);
  });
  if (deliverable) {
    // htkLog("getDeliverable " + deliverable_id + " = " + deliverable.title);    
  } else {
    // htkLog("getDeliverable no deliverable for " + deliverable_id);
  }
  return deliverable;
}

DeliverableTree.prototype.lastChild = function(deliverable_id) {
  // htkLog("DeliverableTree.lastChild " + deliverable_id);
  var node = this.tree.tree('getNodeById', deliverable_id); 
  return _.last(node.children);
}

DeliverableTree.prototype.getParent = function(deliverable_id) {
  return this.tree.tree('getNodeById', deliverable_id).parent.deliverable;
}

