Htk.ArrowKeyView = Ember.View.extend
	KEY_BINDINGS: {
		38: 'moveUp'
		40: 'moveDown'		
	}
	didInsertElement: ->
		this.$().attr({ tabindex: 1 })
		this.$().focus()
	keyDown: (event) ->
		key = this.KEY_BINDINGS[event.keyCode]
		unless key == undefined
			unless this.get("controller").send(key, event)
				event.preventDefault()
