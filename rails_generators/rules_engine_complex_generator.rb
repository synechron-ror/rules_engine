require File.expand_path(File.dirname(__FILE__) + '/manifests/rules_engine_complex')

class RulesEngineComplexGenerator < Rails::Generator::Base

  def initialize(runtime_args, runtime_options = {})
    super
  end

  def after_generate
  end

  def manifest
    record do |m|
      RulesEngineComplexManifest.populate_record(m)
    end
  end
end
