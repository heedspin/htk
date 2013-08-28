DS.RESTAdapter.configure "plurals",
  party: "parties"
  email_summary: "email_summaries"
  message_summary: "message_summaries"

DS.RESTAdapter.registerTransform 'array',
  serialize: (value) -> return ['hello', 'world']
  deserialize: (value) ->	return Ember.create([{address: 'hello'}, {address: 'world'}])

Htk.Store = DS.Store.extend
  revision: 4
  adapter: DS.RESTAdapter.create()

