require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'

class Projects < SourceAdapter
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
        @token = Nokogiri::XML(response.body).xpath("token/guid/text()")
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

   #         req = Net::HTTP::Get.new(uri.path, {'X-TrackerToken' => 'TOKEN'})

    # TODO: write some code here, Query your backend for objects. Put into some variable that is used in sync method below
    raise "Please provide some code to read records from the backend application"
  end
 
  def sync
    # TODO: write code here that converts the data you got back from query into an @result object
    # where @result is an array of hashes,  each array item representing an object
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