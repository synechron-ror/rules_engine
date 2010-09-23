Dir["#{File.dirname(__FILE__)}/manifests/*.rb"].each {|f| require f}

class RulesEngineGenerator < Rails::Generators::Base
  
  source_root File.expand_path(File.dirname(__FILE__) + "/manifests/templates")      
  
  def initialize(runtime_args, *runtime_options)
    super
    @generator = runtime_args[0] unless runtime_args.length < 1
    @rule_type = runtime_args[1] unless runtime_args.length < 2
    @rule_name = runtime_args[2].downcase.gsub(/[^a-zA-Z0-9]+/i, '_') unless runtime_args.length < 3
    @rule_class = @rule_name.camelize unless runtime_args.length < 3
  end
  
  def install
    if @generator == "application"
      RulesEngineManifest.populate_record(this)
      puts RulesEngineGenerator.description_rule
    elsif @generator == "rule"  
      if @rule_type.blank? || @rule_name.blank? 
        puts "    ***************** Cannot Generate rule ***************** "
      else  
        begin
          manifest = Kernel.const_get("#{@rule_type.classify}Manifest")
          manifest.populate_record(self, @rule_name)
        # rescue
        #   puts "    ***************** Cannot find rule class #{@rule_type.classify}Manifest ***************** "  
        end  
      end
      puts RulesEngineGenerator.description_rule  
    else
      puts RulesEngineGenerator.description_all  
    end  
  end
  
  def self.description_all
    <<-DESCRIPTION 
    *******************************************************************    
    To add the rules engine to you application
    > rails generate rules_engine application

    To create a new rule from the simple or complex templates
    > rails generate rules_engine rule [simple|complex] [new_rule_name]    
    Example : 
    > rails generate rules_engine rule simple my_simple_rule
    
    Or to see other rule templates install the rules_engine_templates gem
    > gem install rules_engine_templates
    *******************************************************************    
    DESCRIPTION
  end      
  
  def self.description_rule
    <<-DESCRIPTION 
    *******************************************************************
    To create a new rule from the simple or complex templates
    > rails generate rules_engine rule [simple|complex] [new_rule_name]    
    Example : 
    > rails generate rules_engine rule simple my_simple_rule
    
    Or to see other rule templates install the rules_engine_templates gem
    > gem install rules_engine_templates
    *******************************************************************    
    DESCRIPTION
  end      
  
  desc(description_all)

  protected
    def rule_name
      puts "get rule name #{@rule_name}"
      @rule_name
    end

    def rule_class
      puts "get rule class #{@rule_class}"
      @rule_class
    end
end      
