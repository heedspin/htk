test("Always win", function() {
  equal((1 == 1), true, "always win is losing");
});

test("sortSiblings", function() {
	var unsorted = [
		{ id: 3, parent_relation : { previous_sibling_id : 2 } },
		{ id: 2, parent_relation : { previous_sibling_id : 1 } },
		{ id: 1 },
		{ id: 4, parent_relation : { previous_sibling_id : 3 } }
	];
	var sorted = DeliverableTree.prototype.sortSiblings(unsorted);
	deepEqual(_.map(sorted, function(x) { return x.id; }), [1, 2, 3, 4], "not sorted properly!");
});