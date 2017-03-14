require 'json'

class Dummy



  def import connector
    connection = connector.connection
    connection.source = source
    connection.url = url
    filename = "#{Rails.root.join("lib", "tasks")}/dummy_data.json"
    object = load_user_lib filename
    products = object["products"]
    products.each do |product|
      connection.insert_product product
    end
  end

  def source
    "Dummy"
  end

  def url
    "http://dummyshop.com/"
  end

private
  def load_user_lib( filename )
    File.open( filename, "r" ) do |f|
      JSON.load( f )
    end
  end
end