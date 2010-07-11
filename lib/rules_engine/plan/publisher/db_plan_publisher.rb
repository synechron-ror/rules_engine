module RulesEngine
  module Plan
    
    class RePublishedPlan < ActiveRecord::Base
      named_scope :by_plan_code, lambda {|plan_code| {:conditions => ['plan_code = ?', plan_code]} }
      named_scope :by_version, lambda {|version| {:conditions => ['version = ?', version]} }
      named_scope :order_version, lambda {|version| {:order => "version #{order}"} }
    end
      
    class DbPlanPublisher < Publisher

      def initialize(*options)        
      end
      
      def publish(plan_code, plan)
        re_plan = RePublishedPlan.by_plan_code(plan_code).order_version('DESC').find(:first)
        version = re_plan.nil? ? 1 : re_plan.version + 1
        RePublishedPlan.create(:plan_code => plan_code, :version => 1, :data => plan, :published_at => Time.now.utc)
        
        if RulesEngine::Cache.perform_caching?
          cache_code = "#{plan_code.gsub(/[^a-zA-Z0-9]+/i, '_')}_default"
          RulesEngine::Cache.cache_store.write("re_plan_#{cache_code}", plan)
        end
        
        version
      end
      
      def get(plan_code, version = nil)
        return get_without_caching(plan_code, version) unless RulesEngine::Cache.perform_caching?
        
        cache_code = "#{plan_code.gsub(/[^a-zA-Z0-9]+/i, '_')}_#{version.nil? ? 'default' : version}"
        plan = RulesEngine::Cache.cache_store.read("re_plan_#{cache_code}")
        if (plan.nil?)
          plan = get_without_caching(plan_code, version)
          RulesEngine::Cache.cache_store.write("re_plan_#{cache_code}", plan)
        end            
        plan
      end  
      
      def get_without_caching
        klass = RePublishedPlan
        klass = klass.by_plan_code(plan_code)
        klass = klass.by_version(version) if version
        re_plan = klass.order_version('DESC').find(:first)
        plan = re_plan.nil? ? nil : re_plan.data
      end
      
      def versions(plan_code)
        RePublishedPlan.by_plan_code(plan_code).order_version('DESC').find(:all).map do |re_published_plan|
          { 
            :version => re_published_plan.version, 
            :published_at => re_published_plan.published_at.utc.to_s
          }
        end
      end
    end  
  end  
end
