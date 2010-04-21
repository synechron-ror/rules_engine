require File.expand_path(File.dirname(__FILE__) + '/manifests/rules_engine')

class RulesEngineGenerator < Rails::Generator::Base

  def initialize(runtime_args, runtime_options = {})
    super
  end

  def after_generate
  end

  def manifest
    record do |m|
      RulesEngineManifest.populate_record(m)
      m.readme 'doc/README.rules_engine'
    end
  end
end
