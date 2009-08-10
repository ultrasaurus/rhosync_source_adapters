require 'product_resource'

class Product < SourceAdapter
  def initialize(source,credential)
    super(source,credential)
  end
 
  def login
  end
 
  def query
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&QUERY&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"


    @result = ProductResource.hashinate_all
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&END QUERY&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"     
    @result
  end
 
  def sync
    # TODO: write code here that converts the data you got back from query into an @result object
    # where @result is an array of hashes,  each array item representing an object
    super # this creates object value triples from an @result variable that contains an array of hashes
  end
 
  def create(name_value_list)
    attrvals = {}     
    name_value_list.each { |nv| 
      attrvals[nv["name"].to_sym] = nv["value"] 
    }
    ProductResource.create(attrvals)
  end
 
  def update(name_value_list)
    obj_id = name_value_list.find { |item| item['name'] == 'id' }
     name_value_list.delete(obj_id)
 
     #  The name_value_list:
     #  [{"name"=>"name", "value"=>"iPhone"}]
     attrvals = {}
     name_value_list.each { |nv| attrvals[nv["name"]]=nv["value"]}
 
     # Should be something like:
     # {"name" => "iPhone"}
     product = ProductResource.find(obj_id['value'])
 
     product.attributes = product.attributes.merge(attrvals)
     product.save
  end
 
  def delete(name_value_list)
    obj_id = name_value_list.find { |item| item['name'] == 'id' }
     product = ProductResource.find(obj_id['value'])
     raise "Couldn't find or destroy the product" unless product && product.destroy
  end
 
  def logoff
    #TODO: write some code here if applicable
    # no need to do a raise here
  end
end 
 
 
 
 
