require File.dirname(__FILE__) + '/../../lib/product_shop_inventory'
require File.dirname(__FILE__) + '/../spec_helper'

require 'rubygems'
require 'fakeweb'

describe 'ProductShop' do
  before(:each) do
    @inventory = ProductShop::Inventory.new()
  end

  it 'should provide a list of categories' do
    FakeWeb.register_uri(:get, "http://productshop.heroku.com/categories.xml",
                         :body => <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<categories>
  <category>
    <name>One</name>
    <id>1</id>
  </category>
  <category>
    <name>Two</name>
    <id>2</id>
  </category>
  <category>
    <name>Five</name>
    <id>5</id>
  </category>
</categories>
    EOS
)

    clist = @inventory.categories
    clist.length.should == 3
    c = clist["1"]
    c['name'].should == "One"
    c = clist["5"]
    c['name'].should == "Five"

  end
  
  it 'should provide a list of products for a category' do
    FakeWeb.register_uri(:get, "http://productshop.heroku.com/categories/1.xml",
                         :body => <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<category name="Parts">
  <product>
    <sku>100</sku>
    <name>wheel</name>
    <brand>Acme</brand>
    <price>$30.00</price>
    <quantity>52</quantity>
  </product>
  <product>
    <sku>101</sku>
    <name>axle</name>
    <brand>Acme</brand>
    <price>$104</price>
    <quantity>30</quantity>

  </product>
</category>
    EOS
)

    plist = @inventory.products(1)
    plist.length.should == 2
    wheel = plist["100"]
    wheel['name'].should == "wheel"
    wheel['brand'].should == "Acme"
    wheel['price'].should == "$30.00"
  end
end
