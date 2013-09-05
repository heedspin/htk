Htk.MessageBody = DS.Model.extend
	message: DS.belongsTo('message')
	html_body: DS.attr('string')