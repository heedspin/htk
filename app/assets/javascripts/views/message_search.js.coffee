Htk.MessageSearch = Ember.View.extend
	didInsertElement: ->
		console.log "Hello MessageSearch"
		marioData= [
			{name: "Mario", type: "Protagonist"},
			{name: "Luigi", type: "Protagonist"},
			{name: "Princess Peach", type: "Protagonist"},
			{name: "Toad", type: "Protagonist"},
			{name: "Yoshi", type: "Protagonist"},
			{name: "Toadsworth", type: "Supporting"},
			{name: "Donkey Kong", type: "Supporting"},
			{name: "Princess Daisy", type: "Supporting"},
			{name: "Professor E. Gadd", type: "Supporting"},
			{name: "Rosalina", type: "Supporting"},
			{name: "Pauline", type: "Supporting"},
			{name: "Birdo", type: "Supporting"},
			{name: "Toadette", type: "Supporting"},
			{name: "Bowser", type: "Antagonist"},
			{name: "Bowser Jr", type: "Antagonist"},
			{name: "Fawful", type: "Antagonist"},
			{name: "Kammy Koopa", type: "Antagonist"},
			{name: "Kamek", type: "Antagonist"},
			{name: "King Boo", type: "Antagonist"},
			{name: "Petey Piranha", type: "Antagonist"},
			{name: "Wario", type: "Antagonist"},
			{name: "Waluigi", type: "Antagonist"},
			{name: "Wart", type: "Antagonist"},
			{name: "Koopa Kid", type: "Antagonist"},
			{name: "Tatanga", type: "Antagonist"}
		]
		dbName = "mario"
		marioSearchEngine = new fullproof.BooleanEngine()
		engineReady = ->
			console.log "Engine Ready!"
		initializer = (injector, callback) ->
			synchro = fullproof.make_synchro_point(callback, marioData.length)
			for marioCharacter, i in marioData
				text = marioCharacter.name + " " + marioCharacter.type
				injector.inject(text, i, synchro)
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
		marioSearchEngine.open([index1, index2], 
			fullproof.make_callback(engineReady, true), 
			fullproof.make_callback(engineReady, false))
		@set('marioSearchEngine', marioSearchEngine)
		@set('marioData', marioData)
		sayHello = ->
			console.log "Hello!!!!!!!!!!!"
		Ember.run.later sayHello, 5000

	marioSearchEngine: null
	marioData: null

	input: ->
		value = @get('searchInput')
		marioSearchEngine = @get('marioSearchEngine')
		marioData = @get('marioData')
		marioSearchEngine.lookup value, (resultset) ->
			if resultset and resultset.getSize()
				rsize = resultset.getSize()
				console.log "Found " + rsize + " character"+(if rsize>1 then "s" else "")+" matching your request."
				resultset.forEach (marioCharacter_id) ->
					marioCharacter = marioData[marioCharacter_id]
					console.log marioCharacter.name
			else
				console.log "No result found :-("
