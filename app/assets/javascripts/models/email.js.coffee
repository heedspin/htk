Htk.Email = DS.Model.extend
	date: DS.attr('date')
	subject: DS.attr('string')
	email_account: DS.belongsTo('emailAccount')
	html_body: DS.attr('string')
	parties: DS.hasMany('party')