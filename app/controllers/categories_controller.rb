class CategoriesController < ApplicationController

  def show
    @category = Category.find_by_name(params[:name])
    if @category.blank?
      redirect_to root_path
      return 
    end

    if @category.firstlevel?
      @expand = @category
    else
      @expand = @category.category
    end
      
    @default_image = @category.image.default
    @default_title = @category.category_name
    @auctions = @category.find_ordered_auctions.page(params[:page]).per(16)
    @show_image = true
  end
end
