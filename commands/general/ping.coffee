Command = require "../../structures/Command"

class Ping extends Command
  constructor: (args...) ->
    super args...,
      description: "Pong!"

  run: (msg) ->
    m = await msg.channel.send("Ping?")
    m.edit("Pong! Took **#{m.createdTimestamp - msg.createdTimestamp} ms** API Latency: **#{@client.ws.ping} ms**")

module.exports = Ping
