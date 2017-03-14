class AuctionsController < ApplicationController

  before_filter :check_winner, except: [:bid, :auction_information, :index]


  def update_values
    if params[:detail].present?
      render :json => @auction.to_json_detail
    else
      render :json => @auction.to_json
    end
  end

  def index
    @auctions = Auction.running_auctions.page(params[:page]).per(16)
        @auctions.each{ |a| update_auction(a)}

  end

  def show
    if cookies["auction#{@auction.id}"].blank?
      @auction.increment!(:visits) 
      cookies["auction#{@auction.id}"] = Time.now
    end
  end

  def bid
    @auction = Auction.find(params[:data]) 
    render json: {no_auction: true} if @auction.blank?
    can_bid = current_user && current_user.can_bid? && !@auction.lastbidder?(current_user)
    if can_bid
      @auction.take_bid current_user
      render json: {can_bid:true, bid_count: current_user.bid_count}
    else
      render json: {can_bid:false, lastbidder: @auction.lastbidder?(current_user), credit: (current_user && current_user.can_bid?)}
    end
  end


  def auction_information
    if params[:single]
      @auctions = Auctions.where(:id => params[:auction_id])
    else
      @auctions = Auction.running_auctions.page(params[:page]).per(16)
    end
    @auctions.each{ |a| update_auction(a)}
    formated = format_to_json @auctions

    render json: formated
  end

private
  def format_to_json list
    result = {}
    for item in list do
      result[item.id] = item.to_json
    end
    result
  end

  def check_winner
    find_auction
    #  update_auction @auction if @auction.present?
  end

  def update_auction auction
    return if auction.blank?
    if auction.lastbidder.present?
      return if auction.lastbidder_is_bot?
      return unless auction.lastbidder.created_at < Time.current - 5.seconds 
    end
    return if auction.start >= DateTime.current
    @bot = User.next_bot auction.id
    @bot.increment(:bid_counter)
    auction.take_bid @bot
    @bot.last_auction=auction.id
    @bot.save
  end


  def find_auction
    if params[:data].present?
      @auction = Auction.find(params[:data]) 
    else
      @auction = Auction.find(params[:id])
    end
  end


end
