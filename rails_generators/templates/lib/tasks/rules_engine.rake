require 'active_record'  
require 'rules_engine'

desc "run a rules engine plan"   
task :rules_engine do

  if ENV['re_pipeline_code'].blank?
    raise "usage: rake rules_engine re_pipeline_code=[pipeline code] re_param='[value]'"
  end    
        
  environment = ENV["RAILS_ENV"] || "development"

  dbconfig = YAML::load(File.open("#{File.dirname(__FILE__)}/../../config/database.yml"))[environment]    
  ActiveRecord::Base.establish_connection(dbconfig)
        
  data = ENV.inject({}){ |data, value| data[value[0].sub(/^re_/, '').to_sym] = value[1] if value[0] =~ /^re_/; data }

  RulesEngine::Plan.publisher = :db_publisher
  RulesEngine::Process.runner = :db_process_runner
  RulesEngine::Process.auditor = :db_process_auditor
  RulesEngine::Process.auditor.audit_level = RulesEngine::Process::AUDIT_SUCCESS
  
  # process = RulesEngine::Process.create
  # process = RulesEngine::Process.open(process.re_process.id)
      
  # success = process.run(data[:pipeline_code], data)
  
  # puts "rule #{success ? 'succeeded' : 'failed'} : data = #{data.inspect}"
end

