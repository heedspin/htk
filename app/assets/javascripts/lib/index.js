//= require_self
//= require ./array_synchronizer.js
//= require ./autogrow.js
//= require ./handlebars_helpers.js
//= require ./htk_gadgets.js.erb
//= require ./deliverable_tree.js
//= require ./underscore-min.js
//= require ./htk_joiner.js
//= require ./htk_binding.js
//= require ./bindings

function htkLog() {
  if (console && console.log) {
    console.log.apply(console, arguments);
  }
}
