Htk.MessageBody = DS.Model.extend
	message: DS.belongsTo('Htk.Message')
	html_body: DS.attr('string')