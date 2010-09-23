require "rules_engine"
require "rails"

module RulesEngine
  class Engine < Rails::Engine
      
    initializer "rules_engine.action_view" do |app|
      ActionView::Base.send(:include, RulesEngineView::Alerts)
      ActionView::Base.send(:include, RulesEngineView::Boxes)
      ActionView::Base.send(:include, RulesEngineView::Buttons)
      ActionView::Base.send(:include, RulesEngineView::Navigate)
      ActionView::Base.send(:include, RulesEngineView::Defer)
      
      ActionView::Base.send(:include, RulesEngineView::FormStyles)
      ActionView::Base.send(:include, RulesEngineView::FormFields)
      ActionView::Base.send(:include, RulesEngineView::FormBuilderView)          
    end

    initializer "rules_engine.action_controller" do |app|
      ActionController::Base.send(:include, RulesEngineView::ModelLoader)
    end

    rake_tasks do
      load File.expand_path(File.dirname(__FILE__) + "./../../tasks/rules_engine.rake")
    end    
    
    generators do
      require File.expand_path(File.dirname(__FILE__) + "./../../generators/rules_engine_generator")      
    end    
  end
end
