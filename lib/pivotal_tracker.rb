require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'

module PivotalTracker

  class Account
    # given a valid PivotalTracker name & password, this returns a token
    def initialize(name, password)
      puts "connecting to PivotalTracker: #{name}"
      begin
        uri = URI.parse("https://www.pivotaltracker.com/services/tokens/active")
        http = Net::HTTP.new(uri.host, 443)
        http.use_ssl = true
        req = Net::HTTP::Get.new(uri.path, 'Accept' => 'application/xml')
        req.basic_auth(name, password)
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

    def projects()
      
    end


  end 
end