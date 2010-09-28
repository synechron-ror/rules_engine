require 'active_record'  
require 'rules_engine'

desc "run a rules engine plan"   
task :rules_engine do

  if ENV['plan'].blank?
    raise "usage: rake rules_engine plan=[plan code] re_param='[value]'"
  end    
        
  environment = ENV["RAILS_ENV"] || "development"

  dbconfig = YAML::load(File.open("#{Rails.root}/config/database.yml"))[environment]    
  ActiveRecord::Base.establish_connection(dbconfig)
        
  RulesEngine::Publish.publisher = :db_publisher
  RulesEngine::Process.runner = :db_runner
  RulesEngine::Process.auditor = :db_auditor
  RulesEngine::Process.auditor.audit_level = RulesEngine::Process::AUDIT_INFO
  RulesEngine::Discovery.rules_path = "#{Rails.root}/app/rules"
  RulesEngine::Discovery.discover! 
  
  plan = RulesEngine::Publish.publisher.get(ENV['plan'])
  if plan.nil?
    raise "published plan \"#{ENV['plan']}\" not found"
  end    
    
  data = ENV.inject({}){ |data, value| data[value[0].sub(/^re_/, '').to_sym] = value[1] if value[0] =~ /^re_/; data }  
  process_id = RulesEngine::Process.runner.create  
  success = RulesEngine::Process.runner.run_plan(process_id, plan, data)
      
  puts "plan #{success ? 'succeeded' : 'failed'} : process_id = #{process_id} : data = #{data.inspect}"
end

