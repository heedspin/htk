Htk.EmailAccount = DS.Model.extend
  username: DS.attr('string')
  email_summaries: DS.hasMany('emailSummary')

  short_name: (->
  	this.get("username").split("@")[0]
  ).property()