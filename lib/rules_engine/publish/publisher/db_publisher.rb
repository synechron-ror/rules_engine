module RulesEngine
  module Publish
    
    class RePublishedPlan < ActiveRecord::Base
      named_scope :by_plan_code, lambda {|plan_code| {:conditions => ['plan_code = ?', plan_code]} }
      named_scope :by_plan_version, lambda {|plan_version| {:conditions => ['plan_version = ?', plan_version]} }
      named_scope :order_plan_version, lambda {|order| {:order => "plan_version #{order}"} }
    end
      
    class DbPublisher < Publisher

      def initialize(*options)        
      end
      
      def publish(plan_code, version_tag, plan)
        re_plan = get_re_plan(plan_code)
        plan_version = re_plan.nil? ? 1 : re_plan.plan_version + 1
        RePublishedPlan.create(:plan_code => plan_code, :plan_version => plan_version, :version_tag => version_tag, :data => plan.to_json, :published_at => Time.now.utc)
        
        if RulesEngine::Cache.perform_caching?
          RulesEngine::Cache.cache_store.write(get_cache_code(plan_code), plan)
        end
        
        plan_version
      end
      
      def get(plan_code, plan_version = nil)
        return get_without_caching(plan_code, plan_version) unless RulesEngine::Cache.perform_caching?
        
        plan = RulesEngine::Cache.cache_store.read(get_cache_code(plan_code, plan_version))
        if (plan.nil?)
          plan = get_without_caching(plan_code, plan_version)
          RulesEngine::Cache.cache_store.write(get_cache_code(plan_code, plan_version), plan)
        end            
        
        plan
      end  
      
      def versions(plan_code)
        RePublishedPlan.by_plan_code(plan_code).order_plan_version('DESC').find(:all).map do |re_published_plan|
          { 
            "plan_version" => re_published_plan.plan_version, 
            "version_tag" => re_published_plan.version_tag, 
            "published_at" => re_published_plan.published_at.utc.to_s
          }
        end
      end

      def remove(plan_code, plan_version = nil)
        klass = RePublishedPlan
        klass = klass.by_plan_code(plan_code)
        klass = klass.by_plan_version(plan_version) if plan_version
        klass = klass.order_plan_version('DESC')        
        
        klass.find(:all).map do |re_published_plan|
          re_published_plan.destroy
          RulesEngine::Cache.cache_store.delete(get_cache_code(plan_code, re_published_plan.plan_version)) if RulesEngine::Cache.perform_caching?
        end
        
        RulesEngine::Cache.cache_store.delete(get_cache_code(plan_code)) if RulesEngine::Cache.perform_caching?
      end
      
      def get_cache_code(plan_code, plan_version = nil)
        "re_db_pub_#{plan_code.gsub(/[^a-zA-Z0-9]+/i, '_')}_#{plan_version.nil? ? 'default' : plan_version}"
      end
      
      def get_without_caching(plan_code, verison = nil)
        re_plan = get_re_plan(plan_code, verison)
        plan = re_plan.nil? ? nil : JSON.parse(re_plan.data)
      end
      
      def get_re_plan(plan_code, plan_version = nil)
        klass = RePublishedPlan
        klass = klass.by_plan_code(plan_code)
        klass = klass.by_plan_version(plan_version) if plan_version
        klass = klass.order_plan_version('DESC')
        klass.find(:first)        
      end
    end  
  end  
end
