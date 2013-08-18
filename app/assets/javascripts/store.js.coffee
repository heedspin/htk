DS.RESTAdapter.configure("plurals",
  party: "parties"
)

Htk.Store = DS.Store.extend
  revision: 4
  adapter: DS.RESTAdapter.create()

