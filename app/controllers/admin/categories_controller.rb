class Admin::CategoriesController < Admin::AdminController
  def index
    @categories = Category.where(true).page(params[:page]).per(5)
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = 'Category ist created'
      redirect_to admin_category_path(@category)
    else
      render 'new'
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy if @category
    redirect_to admin_categories_path
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to admin_category_path(@category)
    else
      render 'edit'
    end
  end
  
  def show
    @category = Category.find(params[:id])
  end
end

