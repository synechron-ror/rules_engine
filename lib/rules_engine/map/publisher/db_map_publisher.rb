module RulesEngine
  module Job
    
    class RePublishedMap < ActiveRecord::Base
      named_scope :by_map_code, lambda {|map_code| {:conditions => ['map_code = ?', map_code]} }
      named_scope :by_version, lambda {|version| {:conditions => ['version = ?', version]} }
      named_scope :order_version, lambda {|version| {:order => "version #{order}"} }
    end
      
    class DbMapPublisher < Publisher

      def initialize(*options)        
      end
      
      def publish(map_code, map)
        re_map = RePublishedMap.by_map_code(map_code).order_version('DESC').find(:first)
        version = re_map.nil? ? 1 : re_map.version + 1
        RePublishedMap.create(:map_code => map_code, :version => 1, :data => map, :published_at => Time.now.utc)
        version
      end
      
      def get(map_code, version = nil)
        klass = RePublishedMap.by_map_code(map_code)
        klass = klass.by_version(version) if version
        re_map = klass.find(:first)
        re_map.nil? ? nil : re_map.data
      end  
      
      def versions(map_code)
        RePublishedMap.by_map_code(map_code).order_version('DESC').find(:all).map do |re_publishedmap|
          {:version => re_map.version, :published_at => re_map.published_at.utc.to_s}
        end
      end
    end  
  end  
end