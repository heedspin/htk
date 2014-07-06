function HtkController() {
	this.router = DeliverablesRouter.prototype.instance;
}

HtkController.prototype = Object.create(null);

HtkController.prototype.setStatusMsg = function(text) {
  this.router.statusMsg.empty().append(text);
}