namespace :re do
  
  desc "run a rules pipeline with the complex rule"   
  task :execute => :environment do

    if ENV['re_pipeline_code'].blank?
      raise "usage: rake re:execute re_pipeline_code=[pipeline code] re_param='[value]'"
    end    
  
    re_pipeline_code = false
    data = ENV.reject{ |key, value| !(key =~ /^re_/) }
    
    job = RulesEngine::Job.create
    job = RulesEngine::Job.open(job.re_job.id)
        
    result = job.run(data['re_pipeline_code'], data)
    
    puts "rule completed : data = #{data.inspect}"
  end  
end
