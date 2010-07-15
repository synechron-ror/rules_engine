module RulesEngine  
  module Publish
    
    autoload :DbPublisher, 'rules_engine/publish/publisher/db_publisher'
    
    class << self
      def publisher=(publisher_options)
        type, *parameters = *([ publisher_options ].flatten)

        case type
        when Symbol
          publisher_class_name = type.to_s.camelize
          publisher_class = RulesEngine::Publish.const_get(publisher_class_name)
          @publisher = publisher_class.new(*parameters)
        else
          @publisher = publisher_options
        end
      end

      def publisher
        throw "RulesEngine::Publish::Publisher required" unless @publisher
        @publisher
      end      
    end
    
    class Publisher
      # return the published version
      def publish(plan_code, version_tag, plan)
        throw "RulesEngine::Publish::Publisher required"
        # 1
      end
      
      # return the published plan_version
      def get(plan_code, plan_version = nil)
        throw "RulesEngine::Publish::Publisher required"
      end
      
      # list the published versions
      def history(plan_code, options = {})
        throw "RulesEngine::Publish::Publisher required"                
        # {
        #   :publications => []
        # }
      end

      # remove the plan
      def remove(plan_code, plan_version = nil)
        throw "RulesEngine::Publish::Publisher required"                
      end
      
    end  
  end
end
