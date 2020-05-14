Command = require "../../structures/Command"
{ inspect } = require "util"
fetch = require "node-fetch"
{ compile } = require "coffeescript"

class Eval extends Command
  constructor: (args...) ->
    super args...,
      description: "Evaluates arbitrary CoffeeScript"
      ownerOnly: true
      usage: "eval <code>"
      aliases: ["ev"]

  run: (msg, args) ->
    if not args.length
      return msg.reply("What am I supposed to evaluate?")

    { clean, client } = @

    # Command handler strips extra spaces but for eval we need to preserve the indents.
    # So we reparse the raw input. 
    code = msg.content
      .slice(@client.config.prefix.length) # Slice the prefix.
      .split(" ") # Split by spaces
      .slice(1) # Remove the command.
      .join(" ") # Join them back.
      .trim() # Trim whitespaces.

    # Avoid leaking the token accidentally.
    token = client.token.split("").join("[^]{0,2}")
    rev = client.token.split("").reverse().join("[^]{0,2}")
    filter = new RegExp("#{token}|#{rev}", "g")

    try
      output = eval(compile(code, { bare: true }))
      if (output instanceof Promise) or (Boolean(output) and (typeof output.then is "function") and typeof output.catch is "function")
        output = await output

      output = inspect(output, { depth: 0, maxArrayLength: null })
      output = output.replace(filter, "[TOKEN]")
      output = clean(output)

      if output.length < 1950
        return msg.channel.send(output, { code: "js" })

      try
        { key } = await fetch "https://hastebin.com/documents",
          method: "POST"
          body: output
          .then (res) => res.json()

        return msg.channel.send("Output was too long so it was uploaded to hastebin: https://hastebin.com/#{key}.js")
      catch err
        return msg.channel.send("I tried to upload the output to hastebin but encountered this error #{err.name}:#{err.message}")

    catch err
      return msg.channel.send("The following error occured: ```js\n#{err.stack}```")

    

  clean: (text) ->
    text
      .replace(/`/g, "`" + String.fromCharCode(8203))
      .replace(/@/g, "@" + String.fromCharCode(8203))


module.exports = Eval
