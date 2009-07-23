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
      begin
        @projects = {}

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
          xml.xpath('./projects/project').each do |project_node|
            project = {}
            id = project_node.xpath("./id/text()").to_s
            project['name'] = project_node.xpath("./name/text()").to_s
            puts "project #{id} = #{project.inspect}"
            @projects[id] = project;
          end
        else
          response.error!
        end

      rescue
        puts "*** ERROR ***"
        $stderr.puts $!
        raise "query failed"
      end
      @projects
    end

    def stories(project_id)
      begin
        @stories = {}

        uri = URI.parse("http://www.pivotaltracker.com/services/v2/projects/#{project_id}/stories")
        http = Net::HTTP.new(uri.host)
        req = Net::HTTP::Get.new(uri.path, {'Accept' => 'application/xml', 'X-TrackerToken' => @token})
        response = http.request(req)
        puts response.inspect

        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          # OK
          puts response.body
          xml = Nokogiri::XML(response.body)
          xml.xpath('./stories/story').each do |story_node|
            story = {}
            id = story_node.xpath("./id/text()").to_s
            story_node.children.each do |attr_node|
              story[attr_node.name] = attr_node.text
            end
            @stories[id] = story;
          end
        else
          response.error!
        end

      rescue
        puts "*** ERROR ***"
        $stderr.puts $!
        raise "query failed"
      end
      @stories
    end

  end 
end