$.fn.formToNameValues = function() {
  var a = new Array();
  var fa = this.serializeArray();
  $.each(fa, function() {
    var o = new Object();
    o[this.name] = this.value;
    a.push(o);
  });
  return a;
};