module RhoHelper
  module ClassMethods
    # Receives an array of AR Objects and returns a hash of hashes with each
    # item being like: { "id" => { 'attribute_1' => value_1 } }
    def hashinate(result)
      puts "----------------hashinate"
      hash = {}
      result.each do |p|
        puts "---------- #{p.inspect} ------------"
        attrs = p.attributes.reject { |key, value| value.is_a? Time }
        hash[p.sku.to_s] = attrs
      end
      hash
    end

    def hashinate_all
      puts "===================== hashinate_all"
      @hash = hashinate(find(:all))
      @hash
    end
  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
 
