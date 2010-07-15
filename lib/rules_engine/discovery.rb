module RulesEngine
  class Discovery
    
    @rules_path = nil
    @rule_classes = nil
    @rule_groups = nil
        
    class << self
      def rules_path= path
        @rules_path = path
      end  

      def rules_path
        return @rules_path if @rules_path
        return File.expand_path(File.join(Rails.root, '/app/rules')) if defined?(Rails) && Rails.root
        throw Exception.new("Rails.root or rules_path not defined") 
      end  
      
      def discover!
        @rule_classes = []
        @rule_groups = {}
        
        Dir.glob("#{rules_path}/**/*.rb").each do |rule| 
          require rule
          
          rule_class = Kernel.const_get(File.basename(rule, '.rb').classify)
          @rule_classes << rule_class
          
          group = rule_class.options[:group]
          @rule_groups[group] = [] unless @rule_groups.include?(group)
          @rule_groups[group] << rule_class
          
        end  
        
        @rule_classes.sort! { |left, right| return left.to_s < right.to_s}
        @rule_groups.each { |group, rule_classes| rule_classes.sort!  { |left, right| return left.to_s < right.to_s} }
        @rule_groups.each { |key, value| value.sort }
      end
    
      def rule_classes
        throw Exception.new("RulesEngine::Discovery.discover! required in environment.rb") if @rule_classes.nil?
        @rule_classes
      end

      def rule_groups
        throw Exception.new("RulesEngine::Discovery.discover! required in environment.rb") if @rule_classes.nil?
        @rule_groups
      end
    
      def rule_class(rule_class_name)
        throw Exception.new("RulesEngine::Discovery.discover! required in environment.rb") if @rule_classes.nil?
        @rule_classes.each do |rule|
          return rule if rule.rule_class_name == rule_class_name
        end
        nil
      end
    end
  end
end

