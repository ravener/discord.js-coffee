Command = require "../../structures/Command"

class Reload extends Command
  constructor: (args...) ->
    super args...,
      description: "Reloads a command or event."
      ownerOnly: true
      usage: "reload <command|event>"

  run: (msg, [piece]) ->
    if not piece
      return msg.reply("You didn't specify a piece to reload.")

    piece = @client.commands.get(piece) or @client.events.get(piece)

    if not piece
      return msg.reply("That piece does not exist.")
    
    try
      await piece.reload()
      return msg.channel.send("Successfully reloaded the #{piece.store.name.slice(0, -1)} #{piece.name}")
    catch err
      piece.store.set(piece)
      return msg.channel.send("There was an error reloading #{piece.name}: `#{err.message or err.toString()}`")

module.exports = Reload
