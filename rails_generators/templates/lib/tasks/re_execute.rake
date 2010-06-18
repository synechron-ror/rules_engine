namespace :re do
  
  desc "run a rules pipeline with the complex rule"   
  task :execute => :environment do

    if ENV['re_pipeline_code'].blank?
      raise "usage: rake re:execute re_pipeline_code=[pipeline code] re_param='[value]'"
    end    
  
    re_pipeline_code = false
    data = ENV.reject{ |key, value| !(key =~ /^re_/) }
    
    re_job_id = RulesEngine::JobRunner.create_job          
    result = RulesEngine::JobRunner.run_pipleine(re_job_id, data['re_pipeline_code'], data)
    
    puts "rule completed : data = #{data.inspect}"
  end  
end
