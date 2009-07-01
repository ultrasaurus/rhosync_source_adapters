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
    @result = Nokogiri::XML(response.body)
  end
 
  def sync
    puts "=========================================== sync "
    generic_results = {}
    # @result={"1"=>{"title"=>"Awesome Stuff"},"2"=>{"title"=>"Just One More Thing"}}
    @result.xpath('./projects/project').each do |project|
      result = {}
      id = project.xpath("./id/text()").to_s
      title = project.xpath("./title/text()").to_s
      puts "id: #{id}  title: #{title}"
      result['title'] = title;
      generic_results[id] = result;
    end
    @result = generic_results
    super
  end
 
  def create(name_value_list)
    puts "=========================================== create: #{name_value_list.inspect} "
    uri = URI.parse(@source.url+"/projects.xml")

    name_value_list.each do |item|
      puts "item: #{item.inspect}"
      builder = Nokogiri::XML::Builder.new
      builder.project do
          builder.title item["value"]
        end
      puts "------ XML for item"
      puts builder.to_xml

      req = Net::HTTP::Post.new(uri.path)
      req['Accept'] = "application/xml"
      req['Content-Type'] = "application/xml"
      #req.basic_auth @source.login, @source.password
      req.body=builder.to_xml
      response = Net::HTTP.start(uri.host,uri.port) do |http|
        http.request(req)
      end
      p "response: #{response.code}: #{response.message}"
    end
  end
 
  def update(name_value_list)
    puts "=========================================== update #{name_value_list.inspect} "

    #TODO: write some code here
    # be sure to have a hash key and value for "object"
    raise "Please provide some code to update a single object in the backend application using the hash values in name_value_list"
  end
 
  def delete(name_value_list)
    puts "=========================================== delete #{name_value_list.inspect} "

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