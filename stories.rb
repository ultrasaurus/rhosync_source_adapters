require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'

class Stories < SourceAdapter
  def initialize(source,credential)
    puts "=========================================== init "
    puts "source=#{source.inspect}"
    puts "credential=#{credential.inspect}"
    @login = credential.login
    @password = credential.password
    super(source,credential)
  end

  def login
    puts "=========================================== login "
    puts "@source=#{@source.inspect}"
    puts "@login=#{@login.inspect}"
    puts "@password=#{@password.inspect}"

    begin
      uri = URI.parse("https://www.pivotaltracker.com/services/tokens/active")
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.path, 'Accept' => 'application/xml')
      req.basic_auth(@login, @password)
      response = http.request(req)

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        puts response.body
        @token = Nokogiri::XML(response.body).xpath("token/guid/text()").to_s
        puts "found token=#{@token}"
      else
        response.error!
      end

    rescue
      puts "*** ERROR ***"
      $stderr.puts $!
      raise "login failed"
    end
  end

  def query
    puts "=========================================== query "
    puts "@token=#{@token}"
    begin
      generic_results = {}

      uri = URI.parse("http://www.pivotaltracker.com/services/v2/projects")
      http = Net::HTTP.new(uri.host)
      req = Net::HTTP::Get.new(uri.path, {'Accept' => 'application/xml', 'X-TrackerToken' => @token})
      response = http.request(req)
      puts response.inspect

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        puts response.body
        xml = Nokogiri::XML(response.body)
        xml.xpath('./projects/project').each do |project|
          result = {}
          id = project.xpath("./id/text()").to_s
          result['name'] = project.xpath("./name/text()").to_s
          generic_results[id] = result;
        end
      else
        response.error!
      end

    rescue
      puts "*** ERROR ***"
      $stderr.puts $!
      raise "query failed"
    end
    puts generic_results.inspect
    @result = generic_results
  end

  def sync
    puts "=========================================== sync "
    super # this creates object value triples from an @result variable that contains an array of hashes
  end

  def create(name_value_list)
    #TODO: write some code here
    # the backend application will provide the object hash key and corresponding value
    raise "Please provide some code to create a single object in the backend application using the hash values in name_value_list"
  end

  def update(name_value_list)
    #TODO: write some code here
    # be sure to have a hash key and value for "object"
    raise "Please provide some code to update a single object in the backend application using the hash values in name_value_list"
  end

  def delete(name_value_list)
    #TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the hash values in name_value_list"
  end

  def logoff
    #TODO: write some code here if applicable
    # no need to do a raise here
  end
end