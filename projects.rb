require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'lib/pivotal_tracker'

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
    @account = PivotalTracker::Account.new(@login, @password)
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