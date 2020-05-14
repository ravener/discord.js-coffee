Command = require "../../structures/Command"
{ Permissions } = require "discord.js"

class Invite extends Command
  constructor: (args...) ->
    super args...,
      description: "Invite me to your server!"
  
  run: (msg) ->
    permissions = new Permissions(3072).add(...@store.map((command) => command.botPermissions)).bitfield
    return msg.channel.send("""
    To invite me in your server use the following link:

    Don't be afraid to uncheck any permissions I'll let you know when you try to use a command that needs a permission I don't have.
    <https://discordapp.com/oauth2/authorize?client_id=#{@client.user.id}&permissions=#{permissions}&scope=bot>
    """)

module.exports = Invite
