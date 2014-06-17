CommentsController = function(router) {
	HtkController.call(router);
}

CommentsController.prototype = Object.create(HtkController.prototype, {
	template_directory : { value : "comments" },
	showComment : {
		value : function(deliverable, container, comment) {
			if (!CommentsController.prototype.haveSetupEvents) {
				this.setupEvents(container);
				CommentsController.prototype.haveSetupEvents = true;
			}
			var show_view = $(HandlebarsTemplates[this.template_directory + '/show']({ 
		  	current_user: this.router.currentUser, 
		  	deliverable: deliverable, 
		  	comment: comment
		  }));		  
			container.append(show_view);
		}
	},
	haveSetupEvents : { value : false },
	setupEvents : {
		value : function(container) {
			container.parent().parent().on("mouseenter", "div.comment", function () {
  	    $(this).find(".hiddenedit").show();
	    }).on("mouseleave", "div.comment", function () {
  	    $(this).find(".hiddenedit").hide();
  	  });
		}
	}
})

