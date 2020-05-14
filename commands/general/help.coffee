Command = require "../../structures/Command"
{ MessageEmbed } = require "discord.js"

class Help extends Command
  constructor: (args...) ->
    super args...,
      description: "View help for commands."
      usage: "help [command]"

  run: (msg, [command]) ->
    if command
      cmd = @store.get command
      if not cmd
        return msg.channel.send("That command does not exist.")

      if cmd.nsfw and not msg.channel.nsfw
        return msg.channel.send("You can only view that command's information in an NSFW channel.")

      embed = new MessageEmbed()
        .setTitle("Help - #{cmd.name}")
        .setColor("BROWN")
        .setAuthor(msg.author.tag, msg.author.displayAvatarURL({ size: 64 }))
        .setDescription([
          "**Description:** #{cmd.description}",
          "**Category:** #{cmd.category}",
          "**Aliases:** #{if cmd.aliases.length then cmd.aliases.join(", ") else "None"}",
          "**Cooldown:** #{if cmd.cooldown then "#{cmd.cooldown} Seconds" else "None"}",
          "**Usage:** #{@client.config.prefix}#{cmd.usage}",
          "**Extended Help:** #{cmd.extendedHelp}"
        ].join("\n"))

      return msg.channel.send({ embed })

    map = {} # Map<Category, Array<Command.Name>>
    for command from this.store.values()
      # Check for hidden commands first so if all commands in a category is hidden we won't even show the category.
      continue if command.hidden
      continue if command.ownerOnly and msg.author.id isnt @client.config.owner
      continue if command.nsfw and not msg.channel.nsfw

      if not map[command.category]
        map[command.category] = []
      map[command.category].push(command.name)

      embed = new MessageEmbed()
        .setTitle("Help - Commands")
        .setColor("BROWN")
        .setAuthor(@client.user.tag, @client.user.displayAvatarURL({ size: 64 }))
        .setFooter("For more information about a command run #{@client.config.prefix}help <command>")
      
      # Sort the categories alphabetically.
      keys = Object.keys(map).sort()

      for category in keys
        embed.addField(category, map[category].join(", "))

    return msg.channel.send({ embed })

module.exports = Help
