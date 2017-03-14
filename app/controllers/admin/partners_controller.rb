class Admin::PartnersController < Admin::AdminController

  def index
    @partners = Partner.page(params[:page]).per(8)
  end

  def new
    @partner = Partner.new
  end

  def show
    @partner = Partner.find(params[:id])
  end

  def create
    @partner = Partner.new(params[:partner])
    if @partner.save
      redirect_to admin_partner_path(@partner)
    else
      render 'new'
    end
  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def update
    @partner = Partner.find(params[:id])
    if @partner.update_attributes(params[:partner])
      redirect_to admin_partner_path(@partner)
    else
      render 'edit'
    end
  end

  def destroy
    @partner = Partner.find(params[:id])
    @partner.destroy
    redirect_to admin_partners_path
  end

end