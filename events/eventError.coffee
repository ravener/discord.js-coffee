Event = require "../structures/Event"

class EventError extends Event
  run: (event, err) ->
    console.log("Error in event [#{event.name}]: #{err.stack or err}")

module.exports = EventError
