require 'lib/product_shop_inventory'

class Categories < SourceAdapter
  def initialize(source,credential)
    @inventory = ProductShop::Inventory.new()
  end

  def login
  end

  def query
    puts "=========================================== query "
    @result = @inventory.categories
  end

  def sync
    puts "=========================================== sync "
    super # this creates object value triples from an @result variable that contains an array of hashes
  end

  def create(name_value_list)
    raise "not available"
  end

  def update(name_value_list)
    raise "not available"
  end

  def delete(name_value_list)
    raise "not available"
  end

  def logoff
    #TODO: write some code here if applicable
    # no need to do a raise here
  end
end