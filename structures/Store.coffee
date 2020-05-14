klaw = require "klaw"
path = require "path"

{ Collection } = require "discord.js"

class Store extends Collection
  constructor: (client, name) ->
    super()

    @client = client
    @name = name
    @dir = "#{path.dirname(require.main.filename)}#{path.sep}#{name}"

  set: (piece) ->
    exists = @get piece.name

    if exists
      @delete piece.name

    super.set piece.name, piece
    piece

  delete: (key) ->
    exists = @get(key)
    if not exists
      false
    super.delete key

  load: (file) ->
    filepath = path.join(@dir, file)

    piece = @set new (require filepath)(@client, {
      path: file,
      name: path.parse(filepath).name
    })

    delete require.cache[filepath]
    piece

  loadFiles: ->
    new Promise (resolve, reject) =>
      klaw(@dir)
        .on "data", (item) =>
          if not item.path.endsWith(".js") and not item.path.endsWith(".coffee")
            return

          try
            @load path.relative @dir, item.path
          catch err
            reject(err)
        .on "error", (err) => reject(err)
        .on "end", => resolve(@size)


module.exports = Store
