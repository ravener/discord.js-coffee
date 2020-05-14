Event = require "../structures/Event"
{ Permissions } = require "discord.js"

class Message extends Event
  constructor: (args...) ->
    super args...
    @prefix = @client.config.prefix
    @ratelimits = new Map()

    # Uppercase the first letter kick => Kick
    titleCase = (key) => key[0].toUpperCase() + key.slice(1)

    # CoffeeScript was a little bit of headscratching here
    # So i ended up splitting these into seperate functions.
    cb = (obj, key) =>
      obj[key] = key.toLowerCase().split("_").map(titleCase).join(" ")
      obj

    # Build a friendly permission list, e.g KICK_MEMBERS => Kick Members
    @friendlyPerms = Object.keys(Permissions.FLAGS).reduce(cb, {})

  run: (msg) ->
    # Ignore bots and webhooks
    return if msg.webhookID or msg.author.bot

    # Ensure the bot is in the member cache.
    if msg.guild and not msg.guild.me
      await msg.guild.members.fetch(@client.user)

    # Remind the user the prefix if they mentioned the bot.
    if msg.content is @client.user.toString() or msg.guild and msg.content is msg.guild.me.toString()
      return msg.channel.send("Hi, my prefix is `#{@prefix}`")

    return if not msg.content.startsWith(@prefix)
    
    args = msg.content.slice(@prefix.length).trim().split(/ +/g)
    cmd = args.shift().toLowerCase()
    command = @client.commands.get cmd

    if not command
      return @client.emit "commandUnknown", msg, cmd

    # Check cooldown.
    rl = @ratelimit msg, command
    if typeof rl is "string"
      return msg.channel.send(rl)

    if command.ownerOnly and msg.author.id isnt @client.config.owner
      return msg.channel.send("Sorry but that command is for the owner only.")

    if command.nsfw and not msg.channel.nsfw
      return msg.channel.send("That command can only be used in NSFW channels.")

    if command.guildOnly and not msg.guild
      return msg.channel.send("That command can only be used in a server.")

    if not command.enabled and msg.author.id isnt @client.config.owner
      return msg.channel.send("That command has been disabled by the owner.")

    # Verify the member is in cache if the command is a guild only command.
    if command.guildOnly and not msg.member
      await msg.guild.members.fetch(msg.author)

    return if not await @checkPerms(msg, command)

    msg.channel.startTyping()
    await command._run(msg, args)
    msg.channel.stopTyping()

  ratelimit: (msg, cmd) ->
    return if msg.author.id is @client.config.owner
    return if cmd.cooldown is 0

    cooldown = cmd.cooldown * 1000
    ratelimits = @ratelimits.get(msg.author.id) or {}

    if not ratelimits[cmd.name]
      ratelimits[cmd.name] = Date.now() - cooldown

    difference = Date.now() - ratelimits[cmd.name]

    if difference < cooldown
      msg.channel.send("You can run this command again in **#{Math.round((cooldown - difference) / 1000)} seconds**")
    else
      ratelimits[cmd.name] = Date.now()
      @ratelimits.set(msg.author.id, ratelimits)
      true

  checkPerms: (msg, cmd) ->
    return true if msg.channel.type is "dm"
    
    user = if msg.author.id is @client.config.owner then [] else
      msg.channel.permissionsFor(msg.author).missing(cmd.userPermissions)

    if user.length > 0
      await msg.channel.send("You do not have the following permission#{if user.length > 1 then "s" else ""} to run this command: `#{
        user.map((p) => @friendlyPerms[p]).join(", ")
      }`")
      return false

    bot = msg.channel.permissionsFor(@client.user).missing(cmd.botPermissions)
    if bot.length > 0
      await msg.channel.send("Hey! I need the following permission#{if bot.length > 1 then "s" else ""} to do that: `#{
        bot.map((p) => this.friendlyPerms[p]).join(", ")}`")
      return false

    true

module.exports = Message
