class Admin::AuctionsController < Admin::AdminController

  def index
    symbol = :index
    if params[:future].present?
      @auctions = Auction.future_auctions
      symbol = :future
    elsif params[:past].present?    
      @auctions = Auction.past_auctions 
      symbol = :past
    elsif params[:winning].present?
      symbol = :winning
      @auctions = Auction.joins("INNER JOIN users on winner = users.id").where("users.bot = ?", false).where(checked: true)
    else
      @auctions = Auction.active_auctions 
    end
    current_navigation[symbol]='active'
    @auctions = @auctions.page(params[:page]).per(10)
  end

  def show
    @auction = Auction.find(params[:id])
    current_navigation[:show]='active'
  end

  def new
    @auction = Auction.new
    @auction.product_id = params[:product_id] if  params[:product_id].present?
    current_navigation[:new]='active'
  end

  def create
    @auction = Auction.new(params[:auction])
    @auction.category_id = Product.find(@auction.product_id).category_id if @auction.product_id
    current_navigation[:new]='active'
    if @auction.save
      flash[:notice] = 'Auction ist created'
      redirect_to admin_auction_path(@auction)
    else
      render 'new'
    end
  end

  def edit
    @auction = Auction.find(params[:id])
    current_navigation[:edit]='active'
  end

  def update
    @auction = Auction.find(params[:id])
    current_navigation[:edit]='active'
    if @auction.update_attributes(params[:auction])
      @auction.checked = false
      @auction.save
      redirect_to admin_auction_path(@auction)
    else
      render 'edit'
    end
  end

  def destroy
    
  end




end