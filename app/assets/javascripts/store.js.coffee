DS.RESTAdapter.configure("plurals",
  party: "parties",
  email_summary: "email_summaries"
)

Htk.Store = DS.Store.extend
  revision: 4
  adapter: DS.RESTAdapter.create()

