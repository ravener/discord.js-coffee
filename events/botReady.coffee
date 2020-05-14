Event = require "../structures/Event"

class BotReady extends Event
  run: () ->
    @client.user.setActivity("#{@client.config.prefix}help | #{@client.guilds.cache.size} servers")

module.exports = BotReady
