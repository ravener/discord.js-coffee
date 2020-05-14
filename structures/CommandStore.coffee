Store = require "./Store"
{ Collection } = require "discord.js"

# Stores all the commands.
class CommandStore extends Store
  constructor: (args...) ->
    super args..., "commands"
    @aliases = new Collection()

  get: (name) ->
    # Check if it's an alias
    super.get(name) or @aliases.get(name)

  has: (name) ->
    super.has(name) or @aliases.has(name)

  set: (command) ->
    super.set command

    for alias in command.aliases
      @aliases.set alias, command

    command

  delete: (name) ->
    command = @get name

    if not command
      return

    for alias in command.aliases
      @aliases.delete alias


    super.delete name

  clear: ->
    @aliases.clear()
    super.clear()

module.exports = CommandStore
