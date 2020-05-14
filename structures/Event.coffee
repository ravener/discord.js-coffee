
class Event
  constructor: (client, file, options = {}) ->
    @name = options.name ? file.name
    @client = client
    @file = file
    @enabled = options.enabled ? true
    @store = @client.events

  _run: (args...) ->
    if @enabled
      try
        @run args...
      catch err
        # Avoid recursion if the error handler failed.
        if @name isnt "eventError"
          @client.emit "eventError", @, err

  run: (args...) ->
    await return

  reload: ->
    @store.load @file.path

  enable: ->
    @enabled = true
    @

  disable: ->
    @enabled = false
    @

module.exports = Event
