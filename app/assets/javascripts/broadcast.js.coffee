

class @Broadcast

  @subscriber: {}
  @options:{}

  subscribe: (id, callback)->
    window.BROADCAST.subscriber = this.subscriber || {}
    window.BROADCAST.subscriber[id] = callback

  init: () ->
    setInterval(window.BROADCAST.checkAuctions, 2000)

  checkAuctions: ()->
    $.ajax(
      type: "GET",
      url: '/auctionValues',
      data: @options
    ).success((data) ->
      for key, value of data
        window.BROADCAST.subscriber[key](value) if window.BROADCAST.subscriber[key]
    ).error( ()->
      console.log('Fehler beim Synchronisieren.')
    )


window.BROADCAST = window.BROADCAST ||  new Broadcast()
