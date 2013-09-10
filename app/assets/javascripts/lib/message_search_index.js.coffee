Htk.MessageSearchIndex = Ember.Object.extend
	searchEngine: null
	searchEngineReady: false

	index: (party_id, messages)->
		console.log "MessageSearch Indexing"
		dbName = "messageDB-" + party_id
		searchEngine = new fullproof.BooleanEngine()
		@set 'searchEngine', searchEngine
		_this = this
		engineReady = (success) ->
			_this.set 'searchEngineReady', true
			console.log "Engine Ready! success = " + success
		progressCallback = (percentageComplete) ->
			console.log "Index percentageComplete = " + percentageComplete
		initializer = (injector, callback) ->
			# synchro = fullproof.make_synchro_point(callback, messages.length)
			textArray = messages.map (m) -> m.get('searchable_text')
			valueArray = messages.map (m) -> m.get('id')
			injector.injectBulk	textArray, valueArray, callback,	progressCallback
			# for message in messages
			# 	injector.inject(message.get('searchable_text'), message.id, synchro)
		index1 =
			name: "normalindex"
			analyzer: new fullproof.StandardAnalyzer(fullproof.normalizer.to_lowercase_nomark, fullproof.normalizer.remove_duplicate_letters)
			capabilities: new fullproof.Capabilities().setUseScores(false).setDbName(dbName)
			initializer: initializer
		index2 =
			name: "stemmedindex"
			analyzer: new fullproof.StandardAnalyzer(fullproof.normalizer.to_lowercase_nomark, fullproof.english.metaphone)
			capabilities: new fullproof.Capabilities().setUseScores(false).setDbName(dbName)
			initializer: initializer
		searchEngine.open([index1, index2],	fullproof.make_callback(engineReady, true), fullproof.make_callback(engineReady, false))

	search: (text, callback) ->
		searchEngine = @get('searchEngine')
		searchEngine.lookup text, callback
