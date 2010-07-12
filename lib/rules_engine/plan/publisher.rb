module RulesEngine  
  module Plan
    
    autoload :DbPublisher, 'rules_engine/plan/publisher/db_publisher'
    # autoload :DBPublisher, 'rules_engine/process/publisher/db_publisher'
    
    class << self
      def publisher=(publisher_options)
        type, *parameters = *([ publisher_options ].flatten)

        case type
        when Symbol
          publisher_class_name = type.to_s.camelize
          publisher_class = RulesEngine::Plan.const_get(publisher_class_name)
          @publisher = publisher_class.new(*parameters)
        else
          @publisher = publisher_options
        end
      end

      def publisher
        throw "RulesEngine::Plan::Publisher required" unless @publisher
        @publisher
      end      
    end
    
    class Publisher
      # return the published version
      def publish(plan_code, plan)
        throw "RulesEngine::Plan::Publisher required"
        # 1
      end
      
      # return the published version
      def get(plan_code, version = nil)
        throw "RulesEngine::Plan::Publisher required"
        # { :code => code, 
        #   :workflow => [{:class_name => 'rule_class_one', :data => [:one, :two, :three]},
        #                         {:class_name => 'rule_class_two', :data => [:four, :five, :six]}]
        # }
      end
      
      # list the published versions
      def versions(plan_code)
        throw "RulesEngine::Plan::Publisher required"                
        # [{:version => 2, :published_at => Time.now.utc.to_s}, {:version => 1, :published_at => Time.now.utc.to_s}]
      end

      # remove the plan
      def remove(plan_code, version = nil)
        throw "RulesEngine::Plan::Publisher required"                
      end
      
    end  
  end
end
