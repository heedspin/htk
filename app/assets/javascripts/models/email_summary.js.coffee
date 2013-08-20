Htk.EmailSummary = DS.Model.extend
	date: DS.attr('date')
	subject: DS.attr('string')
	email_account: DS.belongsTo('Htk.EmailAccount')
