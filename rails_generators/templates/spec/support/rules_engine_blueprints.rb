Sham.code   { | index | "CODE_#{index}" }
Sham.title  { | index |  "#{Faker::Lorem.words(2).join(' ')} #{index} #{Faker::Lorem.words(2).join(' ')}" }
Sham.description  { Faker::Lorem.sentence }
# PLANS
RePlan.blueprint do
  code
  title
  description
  plan_status = RePlan::PLAN_STATUS_DRAFT
  plan_version = (0 ... 10).to_a.rand
end
RePlan.blueprint(:draft) do
  plan_status = RePlan::PLAN_STATUS_DRAFT
end
RePlan.blueprint(:changed) do
  plan_status = RePlan::PLAN_STATUS_CHANGED
end
RePlan.blueprint(:published) do
  plan_status = RePlan::PLAN_STATUS_CHANGED
end

# WORKFLOWS
ReWorkflow.blueprint do
  code
  title
  description
end

# RULES
ReRule.blueprint do
  rule_class_name { 'RulesEngine::Rule::Unknown'}
  position = 0
  title
  summary { Sham.description }
end
