require 'active_record'  
require 'rules_engine'

desc "run a rules engine plan"   
task :rules_engine do

  if ENV['re_plan'].blank?
    raise "usage: rake rules_engine re_plan=[plan code] re_param='[value]'"
  end    
        
  environment = ENV["RAILS_ENV"] || "development"

  dbconfig = YAML::load(File.open("#{File.dirname(__FILE__)}/../../config/database.yml"))[environment]    
  ActiveRecord::Base.establish_connection(dbconfig)
        
  RulesEngine::Publish.publisher = :db_publisher
  RulesEngine::Process.runner = :db_runner
  # RulesEngine::Process.auditor = :db_auditor
  # RulesEngine::Process.auditor.audit_level = RulesEngine::Process::AUDIT_SUCCESS
  RulesEngine::Discovery.discover! 
  
  plan = RulesEngine::Publish.publisher.get(ENV['re_plan'])
  if plan.nil?
    raise "published plan \"ENV['re_plan']\" not found"
  end    
  
  puts plan.inspect
  data = ENV.inject({}){ |data, value| data[value[0].sub(/^re_/, '').to_sym] = value[1] if value[0] =~ /^re_/; data }  
  process_id = RulesEngine::Process.runner.create  
  success = RulesEngine::Process.runner.run(process_id, plan, data)
  
  # process = RulesEngine::Process.open(process.re_process.id)
      
  puts "rule #{success ? 'succeeded' : 'failed'} : data = #{data.inspect}"
end

