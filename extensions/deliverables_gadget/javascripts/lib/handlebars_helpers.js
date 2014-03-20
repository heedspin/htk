Handlebars.registerHelper('each_deliverable', function(deliverables, options) {
	var out = '';
	var current_creator_id = null;
	for (var i = 0; i < deliverables.length; i++) {
		var deliverable = deliverables[i];
		if (deliverable.creator_id != current_creator_id) {
			current_creator_id = deliverable.creator_id;
			deliverable = $.extend(true, {new_creator: true}, deliverable);
			out = out + options.fn(deliverable);
		} else {
			out = out + options.fn(deliverable);
		}
	}
	return out;
});
