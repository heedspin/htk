function ProjectsController(router) {
  StandardDeliverablesController.call(this, router);
}

ProjectsController.prototype = Object.create(StandardDeliverablesController.prototype);
