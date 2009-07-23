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
    @account = PivotalTracker::Account.new(@login, @password)
  end
 
  def query
    puts "=========================================== query "
    @result = @account.projects
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