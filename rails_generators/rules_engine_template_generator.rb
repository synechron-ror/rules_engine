require File.expand_path(File.dirname(__FILE__) + '/manifests/rules_engine_template')

class RulesEngineTemplateGenerator < Rails::Generator::Base

  attr_reader :rule_name, :rule_class

  def initialize(runtime_args, runtime_options = {})
    super

    unless runtime_args.length == 0
      @rule_name = runtime_args[0].downcase.gsub(/[^a-zA-Z0-9]+/i, '_')
      @rule_class = @rule_name.camelize
    end  
  end

  def after_generate
  end

  def manifest
    record do |m|
      if @rule_name.blank?
        puts "USAGE ./script/generate rules_engine_template [rule_name]"
      else    
        RulesEngineTemplateManifest.populate_record(m, @rule_name)
      end  
    end  
  end
end
