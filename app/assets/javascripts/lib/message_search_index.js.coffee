Htk.MessageSearchIndex = Ember.Object.extend
	searchEngine: null
	searchEngineReady: false

	search: (text, callback) ->
		searchEngine = @get('searchEngine')
		searchEngine.lookup text, callback

	index: (party, messages)->
		console.log "MessageSearch Indexing"
		dbName = "PartyIndex-" + party.get('id')
		searchEngine = new fullproof.BooleanEngine()
		@set 'searchEngine', searchEngine
		progressCallback = (percentageComplete) ->
			console.log "Index percentageComplete = " + percentageComplete
		initializer = (injector, callback) ->
			# synchro = fullproof.make_synchro_point(callback, messages.length)
			textArray = messages.map (m) -> m.get('searchable_text')
			valueArray = messages.map (m) -> m.get('id')
			injector.injectBulk	textArray, valueArray, callback,	progressCallback
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
		_this = this
		engineReady = (success) ->
			latest_index_timestamp = party.get('index_timestamp')
			local_timestsamp_key = dbName + '_timestamp'
			if cached_index_timestamp = localStorage.getItem(local_timestsamp_key)
				cached_index_timestamp = new Date(cached_index_timestamp)
			console.log "Engine Ready Callback, success = " + success + " latest_index_timestamp = " + latest_index_timestamp + " cached_index_timestamp = " + cached_index_timestamp
			if cached_index_timestamp and (cached_index_timestamp < latest_index_timestamp)
				console.log "Cached index timestamp is < latest index timestamp.  Rebuilding."
				localStorage.removeItem local_timestsamp_key
				searchEngine.clear ->
					console.log dbName + ' search index cleared.  Rebuilding...'
					searchEngine.open([index1, index2],	fullproof.make_callback(engineReady, true), fullproof.make_callback(engineReady, false))
			else
				console.log "Search Engine Ready"
				localStorage.setItem local_timestsamp_key, latest_index_timestamp.toJSON()
				_this.set 'searchEngineReady', true
		searchEngine.open([index1, index2],	fullproof.make_callback(engineReady, true), fullproof.make_callback(engineReady, false))
