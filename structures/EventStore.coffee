Store = require "./Store"

class EventStore extends Store
  constructor: (args...) ->
    super args..., "events"

  set: (event) ->
    super.set event
    @client.on event.name, event._run.bind event
    event

  delete: (name) ->
    event = @get name

    if not event
      return false

    @client.removeAllListeners event.name
    super.delete(name)


module.exports = EventStore
