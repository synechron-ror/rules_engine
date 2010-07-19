Dir["#{File.dirname(__FILE__)}/manifests/*.rb"].each {|f| require f}

class RulesEngineGenerator < Rails::Generator::Base

  attr_reader :rule_type
  attr_reader :rule_name, :rule_class
  
  def initialize(runtime_args, runtime_options = {})
    super
    
    @rule_type = runtime_args[0] unless runtime_args.length < 1
    @rule_name = runtime_args[1].downcase.gsub(/[^a-zA-Z0-9]+/i, '_') unless runtime_args.length < 2
    @rule_class = @rule_name.camelize unless runtime_args.length < 2
  end

  def after_generate
    puts ''
    puts '******************************************************'
    if @rule_type.nil?
      puts 'open doc/README.rules_engine for more instructions'
    elsif @rule_name.blank? || @rule_class.blank?
      puts 'run >rake spec to test the new rule'  
    end      
    puts ''
  end

  def manifest
    record do |m|
      if @rule_type.nil?
        RulesEngineManifest.populate_record(m)
      elsif @rule_name.blank? || @rule_class.blank?
        klass = Kernel.const_get("#{@rule_type.classify}Manifest")
        klass.populate_record(m)
      else  
        klass = Kernel.const_get("#{@rule_type.classify}Manifest")
        klass.populate_record(m, @rule_name ,@rule_class)
      end      
    end
  end
end
