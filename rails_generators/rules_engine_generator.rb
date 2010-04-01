require File.expand_path(File.dirname(__FILE__) + "/generator_manifest")
require File.expand_path(File.dirname(__FILE__) + "/template_manifest")
require File.expand_path(File.dirname(__FILE__) + "/blacklist_word_manifest")
require File.expand_path(File.dirname(__FILE__) + "/simple_manifest")

class RulesEngineGenerator < Rails::Generator::Base
  
  attr_reader :rule_name, :rule_class
  
  def initialize(runtime_args, runtime_options = {})
    super
  end
    
  def after_generate
  end  
  
  def manifest 
    @rule_name = args[0] || 'generator'
    @rule_class = @rule_name.camelize

    record do |m|
      if (@rule_name == 'generator')
        GeneratorManifest.populate_record(m)      
        m.readme './../USAGE'
      elsif (@rule_name == 'blacklist_word')
        BlacklistWordManifest.populate_record(m)        
      elsif (@rule_name == 'simple')
        Simple.populate_record(m)        
      else
        TemplateManifest.populate_record(m, @rule_name)
      end
      
    end
  end
end