moment.fn.formatTimeToday = ->
	now = moment()
	format = "D MMM, YY"
	if this.year() == now.year()
		if this.date() == now.date()
			format = "hA"
		else
			format = "D MMM"
	this.format(format)
