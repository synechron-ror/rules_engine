module RulesEngine
  module Publish
    
    class RePublishedPlan < ActiveRecord::Base
      scope :by_plan_code, lambda {|plan_code| where('plan_code = ?', plan_code) }
      scope :by_plan_version, lambda {|plan_version| where('plan_version = ?', plan_version) }
      scope :order_plan_version, lambda {|order| order("plan_version #{order}") }

      def self.plan(plan_code, options = {})
        klass = self
        klass = klass.by_plan_code(plan_code)
        klass = klass.by_plan_version(options[:version]) if options[:version]
        klass = klass.order_plan_version('DESC')
        klass.find(:first)        
      end
      
      def self.plans(plan_code, options = {})
        klass = self
        klass = klass.by_plan_code(plan_code)
        klass = klass.order_plan_version('DESC')
        klass.find(:all)        
      end
      
    end
      
    class DbPublisher < Publisher

      def initialize(*options)        
      end
      
      def publish(plan_code, version_tag, plan)
        
        re_plan = RePublishedPlan.plan(plan_code, {})
        
        plan_version = re_plan.nil? ? 1 : re_plan.plan_version + 1
        plan.merge!("code" => plan_code, "version" => plan_version, "tag" => version_tag)
        RePublishedPlan.create(:plan_code => plan_code, :plan_version => plan_version, :version_tag => version_tag, :data => plan.to_json, :published_at => Time.now.utc)
        
        if RulesEngine::Cache.perform_caching?
          RulesEngine::Cache.cache_store.write(cache_code(plan_code), plan)
        end
        
        plan_version
      end
      
      def get(plan_code, plan_version = nil)
        return get_plan_without_caching(plan_code, plan_version) unless RulesEngine::Cache.perform_caching?
        
        plan = RulesEngine::Cache.cache_store.read(cache_code(plan_code, plan_version))
        if (plan.nil?)
          plan = get_plan_without_caching(plan_code, plan_version)
          RulesEngine::Cache.cache_store.write(cache_code(plan_code, plan_version), plan)
        end            
        
        plan
      end  
      
      def history(plan_code, options = {})
        re_published_plans = RePublishedPlan.plans(plan_code, options)        
        {
          "publications" => re_published_plans.map do |re_published_plan|
            { 
              "plan_version" => re_published_plan.plan_version, 
              "version_tag" => re_published_plan.version_tag, 
              "published_at" => re_published_plan.published_at.utc.to_s
            }
          end  
        }
      end

      def remove(plan_code, plan_version = nil)
        plans = plan_version.nil? ? RePublishedPlan.plans(plan_code) : [RePublishedPlan.plan(plan_code, :version => plan_version)].compact
        plans.each do |re_published_plan|
          re_published_plan.destroy
          RulesEngine::Cache.cache_store.delete(cache_code(plan_code, re_published_plan.plan_version)) if RulesEngine::Cache.perform_caching?
        end
        
        RulesEngine::Cache.cache_store.delete(cache_code(plan_code)) if RulesEngine::Cache.perform_caching?
      end
      
      protected
        def cache_code(plan_code, plan_version = nil)
          "re_db_pub_#{plan_code.gsub(/[^a-zA-Z0-9]+/i, '_')}_#{plan_version.nil? ? 'default' : plan_version}"
        end
      
        def get_plan_without_caching(plan_code, plan_version = nil)
          re_plan = RePublishedPlan.plan(plan_code, {:version => plan_version})
          re_plan.nil? ? nil : ActiveSupport::JSON.backend.decode(re_plan.data)
        end
    end  
  end  
end
