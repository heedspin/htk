Htk.EmailAccount = DS.Model.extend
  username: DS.attr('string')
  email_summaries: DS.hasMany('Htk.EmailSummary')