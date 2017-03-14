class Admin::OrdersController < Admin::AdminController

  def index
    symbol = :index
    @orders = Order.where(correct: true).order('orders.created_at DESC')
    if params[:payed].present?
      @orders = @orders.includes(:auction).where("auctions.state = ?", Auction.READY_TO_SHIP)
      symbol = :payed
    elsif params[:send].present?
      @orders =  @orders.includes(:auction).where("auctions.state = ?", Auction.CLOSED)      
      symbol = :send
    else
      @orders =  @orders.includes(:auction).where("auctions.state NOT IN (?)", [ Auction.READY_TO_SHIP, Auction.CLOSED])            
    end
    @current_navigation[symbol]='active'
    @orders = @orders.page(params[:page]).per(10)
  end


  def show
    @order = Order.where(id: params[:id]).first
    @current_navigation[:show]='active'
  end


  def edit
    @order = Order.where(id: params[:id]).first
    @current_navigation[:edit]='active'
  end

  def update
    @order = Order.where(id: params[:id]).first
    @auction = @order.auction
    @auction.state = params[:order][:auction][:state]    
    if @auction.save
      redirect_to admin_order_path(@order)
    else
      render 'edit'
    end
  end


end
