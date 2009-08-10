class Tweet < SourceAdapter
    
  def initialize(source,credential)
    super(source,credential)
  end

  def login
  end
  
  def query
    parsed=nil
    open('http://twitter.com/statuses/user_timeline/macboypr0.json?count=1') do |f|
       parsed=JSON.parse(f.read)
    end

    @result = {}
    parsed.each { |item| 
       item_hash = {} 
       item_hash['text'] = item['text']
       item_hash['created_at'] = item['created_at']
       @result[item['id'].to_s] = item_hash
    }
    @result
  end
  
  # this base class sync method now expects a (NEW IN 1.2) "Hash of Hashes generic results" structure.
  # specifically "generic results" is a hash of hashes.  The outer hash is the set of objects (keyed by the ID)
  # the inner hash is the set of attributes
  # you can choose to use or not use the parent class sync in your own RhoSync source adapters
  def sync
   super
  end

  def create(name_value_list)
  end

  def update(name_value_list)
  end

  def delete(name_value_list)
  end

  def logoff
  end
  
  def set_callback(notify_urL)
    
  end
end