namespace :re do
  
  desc "create and run  job"   
  task :run => :environment do
    
    RePipeline.find(:all).each do | re_pipeline |
      1.upto(100) do
        job_id = RulesEngine::JobRunner.create_job      
        puts "Created Job - job_id : #{Time.now.to_s} "  
    
        RulesEngine::JobRunner.run_pipleine(job_id, re_pipeline.code, {})
      end  
    end  
    
  end  
end
