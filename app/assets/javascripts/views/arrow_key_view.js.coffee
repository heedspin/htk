Htk.ArrowKeyView = Ember.View.extend
	KEY_BINDINGS: {
		38: 'moveUp'
		40: 'moveDown'		
	}
	didInsertElement: ->
		this.$().attr({ tabindex: 1 })
		this.$().focus()
	keyDown: (evt) ->
		event = this.KEY_BINDINGS[evt.keyCode]
		unless event == undefined
			this.get("controller").send(event)
