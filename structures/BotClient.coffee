{ Client } = require "discord.js"

# Stores
CommandStore = require "./CommandStore"
EventStore = require "./EventStore"

class BotClient extends Client
  constructor: () ->
    super
      fetchAllMembers: false
      disableMentions: "everyone"
      messageCacheMaxSize: 100
      messageCacheLifetime: 240
      messageSweepInterval: 300

    # Load config
    @config = require "../config.json"

    # Initialize stores
    @commands = new CommandStore(@)
    @events = new EventStore(@)

    @on("ready", @onReady.bind(@))


  onReady: ->
    console.log("Logged in as #{@user.tag} (#{@user.id})")
    @ready = true
    @emit("botReady")

  login: ->
    await @init()
    super.login @config.token

  init: ->
    # Load pieces.
    [commands, events] = await Promise.all([
      @commands.loadFiles(),
      @events.loadFiles()
    ])

    console.log("Loaded #{commands} commands.")
    console.log("Loaded #{events} events.")


module.exports = BotClient
