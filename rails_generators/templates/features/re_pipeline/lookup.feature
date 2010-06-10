Feature: lookup pipelines
  As a rules engine reader user
  I want to lookup a pipeline
  
Background:
  Given I am logged in as a rules engine reader
	Given there are "15" "re_pipelines"
	
Scenario: Lookup the pipelines
  When I am on the lookup re_pipelines page
  Then I should see only "10" re_pipeline results
  Then the re_pipelines results should be ordered

  
