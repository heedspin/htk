Htk.EmailSummary = DS.Model.extend
	date: DS.attr('date')
	subject: DS.attr('string')
	# email_account: DS.belongsTo('emailAccount')
	parties: DS.hasMany('party')
	from_email_accounts: DS.hasMany('emailAccount')
	to_email_accounts: DS.hasMany('emailAccount')
	cc_email_accounts: DS.hasMany('emailAccount')

	destination_email_accounts: (->
    this.get('to_email_accounts').toArray().concat this.get('cc_email_accounts').toArray()
  ).property('to_email_accounts', 'cc_email_accounts')

	isSelected: false