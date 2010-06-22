namespace :re do
  
  desc "run a rules pipeline with the complex rule"   
  task :execute => :environment do

    if ENV['re_pipeline_code'].blank?
      raise "usage: rake re:execute re_pipeline_code=[pipeline code] re_param='[value]'"
    end    
      
    data = ENV.inject({}){ |data, value| data[value[0].sub(/^re_/, '')] = value[1] if value[0] =~ /^re_/; data }
    
    job = RulesEngine::Job.create
    job = RulesEngine::Job.open(job.re_job.id)
        
    result = job.run(ENV['re_pipeline_code'], data)
    
    puts "rule completed : data = #{data.inspect}"
  end  
end
