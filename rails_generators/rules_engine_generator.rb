require File.expand_path(File.dirname(__FILE__) + '/manifests/rules_engine')
require File.expand_path(File.dirname(__FILE__) + '/manifests/rules_engine_simple')
require File.expand_path(File.dirname(__FILE__) + '/manifests/rules_engine_complex')

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
    case @rule_type

    when 'simple'
      if @rule_name.blank? || @rule_class.blank?
        puts 'error rule name required USAGE ./script/generate simple [rule_name]'
      else
        puts 'run >rake spec to test the new rule'  
      end 

    when 'complex'
      if @rule_name.blank? || @rule_class.blank?
        puts 'error rule name required USAGE ./script/generate complex [rule_name]'
      else
        puts 'run >rake spec to test the new rule'  
      end 
           
    when nil
      puts 'open doc/README.rules_engine for more instructions'
    else
      puts 'error rule type not known USAGE ./script/generate [simple|complex] [rule_name]'  
    end      
    puts ''
  end

  def manifest
    record do |m|
      case @rule_type
      when 'simple'
        unless @rule_name.blank? || @rule_class.blank?
          RulesEngineSimpleManifest.populate_record(m, @rule_name ,@rule_class)
        end  
      when 'complex'
        unless @rule_name.blank? || @rule_class.blank?
          RulesEngineComplexManifest.populate_record(m, @rule_name ,@rule_class)
        end  
      when nil  
        RulesEngineManifest.populate_record(m)
      end      
    end
  end
end
