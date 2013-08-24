Htk.Message = DS.Model.extend
  date: DS.attr('date')
  subject: DS.attr('string')
  html_body: DS.attr('string')
  party: DS.belongsTo('Htk.Party')
  from_email_accounts: DS.hasMany('Htk.EmailAccount')
  to_email_accounts: DS.hasMany('Htk.EmailAccount')
  cc_email_accounts: DS.hasMany('Htk.EmailAccount')

  destination_email_accounts: (->
    this.get('to_email_accounts').toArray().concat this.get('cc_email_accounts').toArray()
  ).property('to_email_accounts', 'cc_email_accounts')
  	