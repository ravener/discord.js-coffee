Command = require "../../structures/Command"
Store = require "../../structures/Store"

class Load extends Command
  constructor: (args...) ->
    super args...,
      description: "Loads all commands/events"
      ownerOnly: true
      usage: "load <commands|events>"
    

  run: (msg, [store]) ->
    if not store
      return msg.reply("You need to specify a store to load.")

    store = @client[store]
    if not store instanceof Store
      return msg.reply("That's not a valid store.")

    try
      before = store.size
      await store.loadFiles()
      after = store.size - before
      return msg.channel.send("Successfully reloaded/loaded #{store.size} #{store.name}. #{if after is 0 then "There was nothing new." else "#{after} new #{store.name} were loaded."}")
    catch err
      return msg.channel.send("There was an error loading all files: `#{err.message or err.toString()}`")

module.exports = Load
