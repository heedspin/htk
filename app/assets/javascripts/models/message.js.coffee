Htk.Message = DS.Model.extend
  date: DS.attr('date')
  subject: DS.attr('string')
  html_body: DS.attr('string')
  party: DS.belongsTo('party')
  from_email_accounts: DS.hasMany('emailAccount')
  to_email_accounts: DS.hasMany('emailAccount')
  cc_email_accounts: DS.hasMany('emailAccount')
  hidden: DS.attr('boolean')

  destination_email_accounts: (->
    this.get('to_email_accounts').toArray().concat this.get('cc_email_accounts').toArray()
  ).property('to_email_accounts', 'cc_email_accounts')
  	