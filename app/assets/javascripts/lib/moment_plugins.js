moment.fn.formatTimeToday = function () {
	var now = moment(),
 		format = "d MMM";
	if (this.date() === now.date() && 
	  Math.abs(this.diff(now)) < 86400000) {
	  // same day of month and less than 24 hours difference
	  if (this.minutes() === 0) {
			format = "hA";
	  } else {
	    format = "h:mmA";
	  }
	}
	return this.format(format);
}
