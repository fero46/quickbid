require 'open-uri'

class DatabaseActions

  def connection
    ProductConnection.new
  end

end


class ProductConnection

  attr_accessor :source, :url

  def insert_product product
    values = {:remote_id => product["id"], 
                :brand => product["brand"],
                :short_description => product["item"],
                :description => product["description"].join("\n"),
                :price => product["price"],
                :online_shop => source,
                :shop_url => url}
    new_product = Product.where(:remote_id => product["id"],:online_shop => source).first
    unless  new_product
          new_product = Product.new(values)
    else
      new_product.update_attributes(values)
    end

    if new_product.new_record?
      new_product.save!
      product["images"].each do |image|
        product_image = new_product.product_images.build
        product_image.remote_image_url = image
        product_image.save!
      end
    end
  end

end