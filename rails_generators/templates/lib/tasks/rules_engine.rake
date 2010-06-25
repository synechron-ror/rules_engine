desc "run a rules pipeline with the complex rule"   
task :rules_engine => :environment do

  if ENV['re_pipeline_code'].blank?
    raise "usage: rake rules_engine re_pipeline_code=[pipeline code] re_param='[value]'"
  end    
    
  data = ENV.inject({}){ |data, value| data[value[0].sub(/^re_/, '').to_sym] = value[1] if value[0] =~ /^re_/; data }
  
  job = RulesEngine::Job.create
  # job = RulesEngine::Job.open(job.re_job.id)
      
  success = job.run(data[:pipeline_code], data)
  
  puts "rule #{success ? 'succeeded' : 'failed'} : data = #{data.inspect}"
end

