module RulesEngine  
  module Map
    
    autoload :DbMapPublisher, 'rules_engine/map/publisher/db_map_publisher'
    # autoload :DBPublisher, 'rules_engine/job/publisher/db_publisher'
    
    class << self
      def publisher=(publisher_options)
        type, *parameters = *([ publisher_options ].flatten)

        case type
        when Symbol
          publisher_class_name = type.to_s.camelize
          publisher_class = RulesEngine::Job.const_get(publisher_class_name)
          @publisher = publisher_class.new(*parameters)
        when nil
          @publisher = nil
        else
          @publisher = publisher_options
        end
      end

      def @publisher
        throw "RulesEngine::Map::Publisher required" unless @publisher
        @publisher
      end      
    end
    
    class Publisher
      # return the published version
      def publish(map_code, map)
        throw "RulesEngine::Map::Publisher required"
        # 1
      end
      
      # return the published version
      def get(map_code, version = nil)
        throw "RulesEngine::Map::Publisher required"
        # { :map_code => map_code, 
        #   :start_pipeline_code => "default", 
        #   :pipeline_default => [{:class_name => 'rule_class_one', :data => [:one, :two, :three]},
        #                         {:class_name => 'rule_class_two', :data => [:four, :five, :six]}]
        #   }.to_json
      end
      
      # list the published versions
      def versions(map_code)
        throw "RulesEngine::Map::Publisher required"                
        # [{:version => "1", :published_at => Time.now.utc.to_s}, {:version => "2", :published_at => Time.now.utc.to_s}]
      end
    end  
  end
end
