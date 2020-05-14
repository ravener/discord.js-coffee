Command = require "../../structures/Command"
{ version } = require "discord.js"
{ VERSION } = require "coffeescript"

class Stats extends Command
  constructor: (args...) ->
    super args...,
      description: "View bot statistics"

  run: (msg) ->
    msg.channel.send """
    = Stats =

    Memory Usage  :: #{(process.memoryUsage().heapUsed / 1024 / 1024).toFixed(2)} MB
    Users         :: #{@client.users.cache.size}
    Guilds        :: #{@client.guilds.cache.size}
    Channels      :: #{@client.channels.cache.size}
    Discord.js    :: #{version}
    Node.js       :: #{process.version}
    CoffeeScript  :: #{VERSION}
    """,
      code: "asciidoc"


module.exports = Stats
