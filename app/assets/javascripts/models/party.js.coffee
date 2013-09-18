Htk.Party = DS.Model.extend
  name: DS.attr('string')
  index_timestamp: DS.attr('date')
  # messages: DS.hasMany('Htk.Message')