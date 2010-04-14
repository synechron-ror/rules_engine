# PIPELINES
RePipeline.blueprint do
  title         { | index |  "#{Faker::Lorem.words(2).join(' ')} #{index} #{Faker::Lorem.words(2).join(' ')}" }
  description   { Faker::Lorem.sentence }
end

RePipelineActivated.blueprint do
  title         { | index |  "#{Faker::Lorem.words(2).join(' ')} #{index} #{Faker::Lorem.words(2).join(' ')}" }
  description   { Faker::Lorem.sentence }
end

