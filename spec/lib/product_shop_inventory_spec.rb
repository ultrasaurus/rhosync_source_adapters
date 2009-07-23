require File.dirname(__FILE__) + '/../../lib/product_shop_inventory'
require File.dirname(__FILE__) + '/../spec_helper'

require 'rubygems'
require 'fakeweb'

describe 'ProductShop' do
  before(:each) do
    @inventory = ProductShop::Inventory.new()
  end

  it 'should provide a list of products' do
    FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v2/projects",
                         :body => <<-EOS
[{"product": {"name": "wheel", "brand": "Acme", "updated_at": "2009-07-23T18:08:12Z", "price": "$30.00", "quantity": "52", "id": 1, "sku": "100", "created_at": "2009-07-23T18:08:12Z"}},
 {"product": {"name": "axle", "brand": "Acme", "updated_at": "2009-07-23T18:09:09Z", "price": "$104", "quantity": "30", "id": 2, "sku": "101", "created_at": "2009-07-23T18:09:09Z"}},
 {"product": {"name": "Hovercraft", "brand": "Ford", "updated_at": "2009-07-23T18:09:34Z", "price": "$30,000", "quantity": "1", "id": 3, "sku": "900", "created_at": "2009-07-23T18:09:34Z"}}]

    EOS
)

    plist = @inventory.products
    plist.length.should == 3
    wheel = plist["1"]
    wheel['name'].should == "wheel"
    wheel['brand'].should == "Acme"
  end
end
