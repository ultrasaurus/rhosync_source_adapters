class SimpleRest < SourceAdapter
  require 'nokogiri'

  def initialize(source,credential)
    puts "=========================================== init "

    super(source,credential)
  end
 
  def login
    puts "=========================================== login "

    #TODO: Write some code here
    # use the variable @source.login and @source.password
    #raise "Please provide some code to perform an authenticated login to the backend application"
  end
 
  def query
    puts "=========================================== query "
    uri = URI.parse(@source.url+"/projects.xml")
    req = Net::HTTP::Get.new(uri.path, 'Accept' => 'application/xml')
    #req.basic_auth @source.login, @source.password
    response = Net::HTTP.start(uri.host,uri.port) do |http|
      http.request(req)
    end
    p "calling nokogiri"
    p response.body
    @result = Nokogiri::XML(response.body)
  end
 
  def sync
    puts "=========================================== sync "
    puts @result.inspect

  end
 
  def create(name_value_list)
    puts "=========================================== create "

    #TODO: write some code here
    # the backend application will provide the object hash key and corresponding value
    raise "Please provide some code to create a single object in the backend application using the hash values in name_value_list"
  end
 
  def update(name_value_list)
    puts "=========================================== update "

    #TODO: write some code here
    # be sure to have a hash key and value for "object"
    raise "Please provide some code to update a single object in the backend application using the hash values in name_value_list"
  end
 
  def delete(name_value_list)
    puts "=========================================== delete "

    #TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the hash values in name_value_list"
  end
 
  def logoff
    puts "=========================================== logoff "

    #TODO: write some code here if applicable
    # no need to do a raise here
  end
end