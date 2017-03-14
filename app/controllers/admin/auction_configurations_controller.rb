# coding: utf-8
class Admin::AuctionConfigurationsController < Admin::AdminController

	def index
		symbol = :index
		@auction_configurations = AuctionConfiguration.where(true).page(params[:page]).per(10)
		current_navigation[symbol]='active'
	end

	def new
		symbol = :new
		current_navigation[symbol]='active'
		@auction_configuration = AuctionConfiguration.new
	end

	def edit
		symbol = :edit
		current_navigation[symbol]='active'
		@auction_configuration = AuctionConfiguration.find(params[:id])
	end

	def create
		symbol = :new
		current_navigation[symbol]='active'
		@auction_configuration = AuctionConfiguration.new(params[:auction_configuration])
		if @auction_configuration.save
      flash[:notice] = 'Auction Configuration ist erstellt'
      redirect_to admin_auction_configurations_path()
    else
      render 'new'
    end
	end

	def update
		@auction_configuration = AuctionConfiguration.find(params[:id])
    current_navigation[:edit]='active'
    if @auction_configuration.update_attributes(params[:auction_configuration])
      redirect_to admin_auction_configurations_path()
    else
      render 'edit'
    end
	end

 def destroy
    @auction_configuration = AuctionConfiguration.find(params[:id])
    @auction_configuration.destroy
    flash[:notice] = 'Auction Configuration ist gelöscht'
		redirect_to admin_auction_configurations_path(@post) 
  end

end
