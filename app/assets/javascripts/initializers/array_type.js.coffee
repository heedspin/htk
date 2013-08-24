DS.RESTAdapter.registerTransform 'array',
	serialize: (value) ->
		return value;
  deserialize: (value) ->
		return Ember.create(value);

