class OrdersController < ApplicationController

  before_filter :check_authorization, :except => :index
  before_filter :authenticate_user!, :only => :index
  
  def index
    @orders = current_user.orders.where(correct: true).page(params[:page]).per(10)
  end

  def show
    @order = @auction.order
    redirect_to root_path if @order.user.id != current_user.id
    redirect_to new_auction_order_path(@auction) unless @order.correct
  end

  def new
    destroy_or_redirect_to_order
    @order = Order.new(auction_id: @auction.id)
    @auction.variation_groups.each do |group_name|
      @order.order_variations.build(group_name: group_name)
    end
    
  end

  def create
    destroy_or_redirect_to_order
    @order = Order.new(params[:order])
    @order.auction_id = @auction.id
    @order.correct = false
    @order.user_id = current_user.id
    if @order.save
      render 'confirm'
    else
      render 'new'
    end
  end

  def edit
    @order = @auction.order
  end

  def update
    @order = @auction.order
    if params[:update].present?
      @order.correct = params[:update]
      @order.save!
      redirect_to auction_order_path(@auction)
    else
      @order.correct = false
      @order.user_id = current_user.id
      @order.update_attributes(params[:order])
      render 'confirm'
    end
  end

  def destroy_or_redirect_to_order
    @order = @auction.order
    if @order.present? && @order.correct
      redirect_to auction_order_path(@auction)
      return
    elsif @order.present?
      @order.destroy
    end
  end


private

  def check_authorization
    if invalid_user?
      redirect_to root_path
    end
  end

  def invalid_user?
    !valid_user?
  end

  def valid_user?
    @auction = Auction.find(params[:auction_id])
    return false if @auction.blank?
    return false if !@auction.time_is_over?
    return false if current_user.blank?
    @auction.lastbidder.user.id == current_user.id
  end

end
