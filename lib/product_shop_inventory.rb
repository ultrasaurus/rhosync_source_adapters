require "open-uri"
require "json"

module ProductShop

  class Inventory

    def products
      product_hashes = nil
      open("http://productshop.heroku.com/products.json") do |f|
        # get an array of products, each is a hash with its value another hash of the product attributes
        # {"product"=>{"brand"=>"Michelin", "name"=>"inner tube", ...}}
        product_hashes=JSON.parse(f.read)
      end
      @result={}
      if !product_hashes.empty?
        product_hashes.each do |item|
           attrs = item["product"]
           id = attrs["id"].to_s  # note: id must be a string
           @result[id]=attrs
        end
      end
      @result

    end

  end

end

