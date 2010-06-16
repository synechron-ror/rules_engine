Sham.code   { | index | "CODE_#{index}" }
Sham.title  { | index |  "#{Faker::Lorem.words(2).join(' ')} #{index} #{Faker::Lorem.words(2).join(' ')}" }

# PIPELINES
RePipeline.blueprint do
  code
  title
  description   { Faker::Lorem.sentence }
end

RePipelineActivated.blueprint do
  code
  title 
  description   { Faker::Lorem.sentence }
end

