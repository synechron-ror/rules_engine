module RulesEngine  
  module Plan
    
    autoload :DbPlanPublisher, 'rules_engine/plan/publisher/db_plan_publisher'
    # autoload :DBPublisher, 'rules_engine/process/publisher/db_publisher'
    
    class << self
      def publisher=(publisher_options)
        type, *parameters = *([ publisher_options ].flatten)

        case type
        when Symbol
          publisher_class_name = type.to_s.camelize
          publisher_class = RulesEngine::Plan.const_get(publisher_class_name)
          @publisher = publisher_class.new(*parameters)
        when nil
          @publisher = nil
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
        # { :plan_code => plan_code, 
        #   :start_workflow_code => "default", 
        #   :workflow_default => [{:class_name => 'rule_class_one', :data => [:one, :two, :three]},
        #                         {:class_name => 'rule_class_two', :data => [:four, :five, :six]}]
        #   }.to_json
      end
      
      # list the published versions
      def versions(plan_code)
        throw "RulesEngine::Plan::Publisher required"                
        # [{:version => "1", :published_at => Time.now.utc.to_s}, {:version => "2", :published_at => Time.now.utc.to_s}]
      end
    end  
  end
end
