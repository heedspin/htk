Htk.Email = DS.Model.extend
	date: DS.attr('date')
	subject: DS.attr('string')
	email_account: DS.belongsTo('Htk.EmailAccount')
	html_body: DS.attr('string')
	parties: DS.hasMany('Htk.Party')