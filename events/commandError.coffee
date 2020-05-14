Event = require "../structures/Event"

class CommandError extends Event
  run: (msg, cmd, err) ->
    console.log("Error in command [#{cmd.name}]: #{err.stack or err}")

module.exports = CommandError
