{ Permissions } = require "discord.js"
{ sep } = require "path"

class Command
  constructor: (client, file, options) ->
    @name = options.name ? file.name
    @client = client
    @file = file
    @description = options.description ? "No Description Provided."
    @extendedHelp = options.extendedHelp ? "No extended help provided."
    @ownerOnly = options.ownerOnly ? false
    @aliases = options.aliases ? []
    @cooldown = options.cooldown ? 0
    @nsfw = options.nsfw ? false
    path = file.path.split(sep)[0]
    @category = options.category ? path[0].toUpperCase() + path.slice(1)
    @guildOnly = options.guildOnly ? false
    @hidden = options.hidden ? false
    @enabled = options.enabled ? true
    @usage = options.usage ? @name
    @botPermissions = new Permissions(options.botPermissions ? []).freeze()
    @userPermissions = new Permissions(options.userPermissions ? []).freeze()
    @store = @client.commands

  _run: (msg, args) ->
    if @enabled
      try
        @run msg, args
      catch err
        @client.emit "commandError", msg, @, err

  run: (msg, args) ->
    msg.channel.send("Missing `run()` in `#{@file.path}`")

  reload: ->
    @store.load @file.path

  disable: ->
    @enabled = false
    @

  enable: ->
    @enabled = true
    @

module.exports = Command
