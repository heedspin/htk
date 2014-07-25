function HtkController(router) {
	this.router = router;
}

HtkController.prototype = Object.create(null, {
	getCurrentUser : {
		value : function() {
			return this.router.currentUser;
		}
	}
});

HtkController.prototype.setStatusMsg = function(text) {
  this.router.statusMsg.empty().append(text);
}