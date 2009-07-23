require "open-uri"
require "json"
require "nokogiri"

module ProductShop

  class Inventory

    def categories
      xml = nil
      result = {}
      open("http://productshop.heroku.com/categories.xml") do |f|
        xml = Nokogiri::XML(f.read)
      end
      xml.xpath('./categories/category').each do |product_node|
        id = product_node.xpath("./id/text()").to_s
        name = product_node.xpath("./name/text()").to_s
        result[id] = {'name' => name} 
      end
      result
    end

    def products(category_id)
      xml = nil
      result = {}
      open("http://productshop.heroku.com/categories/#{category_id}.xml") do |f|
        xml = Nokogiri::XML(f.read)
      end
      xml.xpath('./category/product').each do |product_node|
        id = product_node.xpath("./sku/text()").to_s
        attr_hash = {}
        product_node.children.each do |attr_node|
          attr_hash[attr_node.name] = attr_node.text
        end
        result[id] = attr_hash
      end
      result

    end

  end

end

