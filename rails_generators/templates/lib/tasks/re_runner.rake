namespace :re do
  
  desc "create and run  job"   
  task :run => :environment do
    
    job_id = RulesEngine::JobRunner.create_job      
    puts "Created Job - job_id : #{Time.now.to_s} "  
    
    RulesEngine::JobRunner.run_pipleine(job_id, 'test', {})
    
  end  
end
