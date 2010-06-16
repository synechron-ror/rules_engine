namespace :re do
  
  desc "run a rules pipeline with the <%=rule_name%> rule"   
  task :<%=rule_name%>_rule => :environment do

    if ENV['pipeline_code'].blank? || ENV['sentence'].blank?
      raise "usage: rake re:<%=rule_name%>_rule pipeline_code=[pipeline code] sentence='[sentence to test]'"
    end    
    
    puts "test the sentence : #{ENV['sentence']} in the pipeline #{ENV['pipeline_code']}"

    data = {:sentence => ENV['sentence']}
    
    re_job_id = RulesEngine::JobRunner.create_job          
    RulesEngine::JobRunner.run_pipleine(re_job_id, ENV['pipeline_code'], data)
    
    puts "match found : #{data[:match]}" unless data[:match].blank?
  end  
end
