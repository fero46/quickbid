class Admin::ProductsController < Admin::AdminController

  def index
    @filter = params[:filter]
    @products = AuctionConfiguration.find(params[:filter]).products if @filter
    if @products
      @products.order("short_description")
    else
      @products = Product.order("short_description")
    end
    @products = @products.page(params[:page]).per(10)
    if params[:search]
      s = "%#{params[:search]}%"
      @products = @products.where("short_description like ?", s)
    end
    respond_to do |format|
      format.html  
      format.json { render :json => [@products, :page => {:total => @products.total_pages, :current => @products.current_page}] }
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to admin_product_path(@product)
    else
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
    @auctions = Auction.where(:product_id => @product.id).order("id")
    @auctions = @auctions.page(params[:page]).per(5)
  end


  def edit
    @product = Product.find(params[:id])
  end


  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to admin_product_path
    else
      render 'edit'
    end
  end


end
