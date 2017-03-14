

class @Auction

  @timer_continue: true
  @auctionId: 0
  @detail: false
  @firstTime: true
  @selector: 'none' 

  init: (auctionId, detail) ->
    @firstTime = true
    @detail = detail
    @auctionId = auctionId
    thisAuction = this
    @selector = "#timer"+auctionId
    window.BROADCAST = window.BROADCAST ||  new Broadcast()
    window.BROADCAST.subscribe(auctionId, (data) -> 
      thisAuction.update_value(data)
    )

  update_countdown: ->
    date= $(@selector).attr('data-ending-time').replace(/\-/g,'\/').replace(/[T|Z]/g,' ');
    date= date.replace(" +", "+").replace("+", " +");
    liftoffTime = new Date(date);
    $(@selector).countdown({until: liftoffTime, format: 'HMS', onTick: this.watchCountdown, onExpiry: this.reloadPage});
    
  watchCountdown: (periods) ->
    if ($.countdown.periodsToSeconds(periods) < 60)
      selector=this
      $(this).stop().css("background-color", "#e86566").animate({backgroundColor: "#eee"}, 500, ->
        $(selector).css("background-color", '#eee');
      )
  reloadPage: () ->
    setTimeout( -> 
      window.location.reload();
    , 1000) if $("#detail_check")[0]

  updateTimerValues: () ->
    delayed = this
    $.ajax(
      type: "POST",
      url: '/timerUpdate',
      data: {data:@auctionId},
      dataType: "json"
    ).success( (data) ->
      delayed.seconds = data.seconds
      delayed.minutes = data.minutes
      delayed.hours = data.hours 
    )
  number_to_currency: (number, options) ->
    try 
      options   = options || {};
      precision = options["precision"] || 2;
      unit      = options["unit"] || "€";
      if precision > 0
        separator =  options["separator"] || ",";
      else
        separator= ""
      delimiter = options["delimiter"] || ".";
      parts = parseFloat(number).toFixed(precision).split('.');
      this.number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString() + " "+ unit;
    catch e
      console.log(e)
      return number

  number_with_delimiter: (number, delimiter, separator) ->
    try
      delimiter = delimiter || ",";
      separator = separator || ".";
      parts = number.toString().split('.');
      parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
      return parts.join(separator);
    catch e 
      return number

  update_value: (data) ->
    latest = $("#latest"+@auctionId)
    price = $("#price"+@auctionId)
    oldLatest = latest.text()
    oldPrice = price.text()
    latest.text(data.lastbidder) if(data.lastbidder != null)
    price.text(this.number_to_currency(data.price));
    this.animate_and_go_white(latest) if oldLatest != latest.text()
    this.animate_and_go_white(price) if oldPrice != price.text()
    if(@detail)
      items = eval(data.bid_history);
      $("#bidlist_history").html('')
      this.append_bidlist_history(item) for item in items
    $(@selector).attr('data-ending-time', data.finished)
    $(@selector).countdown('destroy'); 
    this.update_countdown()

  append_bidlist_history: (value) ->
    li= "<li>"+value['time']+" - "+value['user']+"</li>"
    $("#bidlist_history").append(li);

  animate_and_go_white: (selector) ->
    selector.stop().css("background-color", "#e86566").animate({backgroundColor: "#ffffff"}, 500, ->
      $(selector).css("background-color", 'rgba(0, 0, 0, 0)');
    )

  bid_now: () ->
    myauction = this
    $.ajax(
      type: "POST",
      url: '/bid_auction',
      data: {data:@auctionId},
      dataType: "json" 
    ).success( (data) ->
      if(data.can_bid)
        myauction.highlight("#succi"+myauction.auctionId)
        $("#bidcounter").text(data.bid_count)
      else if(!data.credit)
        myauction.highlight("#posi"+myauction.auctionId)
      else
        myauction.highlight("#noli"+myauction.auctionId)
    )

  highlight: (selector) ->
    $('.info').show();
    $(selector).fadeIn("fast", ->
      $(this).delay(1500).fadeOut("fast", ->
        $('.info').hide()
      )
    ).css('display', 'table');

  @initAuction: (id, detail) ->
    auction = new Auction
    auction.init(id, detail)
    $("#bid"+id).click(->
      auction.bid_now();
    )
    auction.update_countdown()