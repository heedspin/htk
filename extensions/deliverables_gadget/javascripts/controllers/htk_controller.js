function HtkController(router) {
	this.router = router;	
}

HtkController.prototype = Object.create(null);

HtkController.prototype.setStatusMsg = function(text) {
  this.router.statusMsg.empty().append(text);
}