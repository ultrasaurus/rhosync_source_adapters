require 'lib/product_shop_inventory'

class Products < SourceAdapter
  def initialize(source,credential)
    super(source,credential)
    @inventory = ProductShop::Inventory.new()
  end

  def login
  end

  def query
    puts "=========================================== Products query "
    @result = {}
    puts "qparams=#{qparams}"
    begin
      @result = @inventory.products(1)
      puts @result.inspect
    rescue
      puts "*** ERROR ***"
      $stderr.puts $!
      raise "query failed"
    end
    @result
  end

  def sync
    puts "=========================================== Products sync "
    super # this creates object value triples from an @result variable that contains an array of hashes
  end

  def create(name_value_list)
    puts "=========================================== Products create "
    raise "not available"
  end

  def update(name_value_list)
    puts "=========================================== Products update "

    raise "not available"
  end

  def delete(name_value_list)
    puts "=========================================== Products delete "

    raise "not available"
  end

  def logoff
    #TODO: write some code here if applicable
    # no need to do a raise here
  end
end