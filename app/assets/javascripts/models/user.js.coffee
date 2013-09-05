Htk.User = DS.Model.extend
  email: DS.attr('string')
  email_accounts: DS.hasMany('emailAccount')
