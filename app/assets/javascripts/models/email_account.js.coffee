Htk.EmailAccount = DS.Model.extend
  username: DS.attr('string')
  emails: DS.hasMany('Htk.Email')