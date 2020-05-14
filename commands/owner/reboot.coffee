Command = require "../../structures/Command"

class Reboot extends Command
  constructor: (args...) ->
    super args...,
      description: "Reboots the bot."
      ownerOnly: true
      aliases: ["shutdown"]

  run: (msg) ->
    await msg.channel.send("Rebooting...")

    # We assume you use pm2 or something similar that automatically restarts.
    # Otherwise this is basically a shutdown command.
    # Feel free to do extra cleanup here in the future, e.g close any database connections.
    process.exit()


module.exports = Reboot
