Htk.Message = DS.Model.extend
  subject: DS.attr('string')
  party: DS.belongsTo('Htk.Party')
