module RulesEngine
  ##################################################################
  class Discovery
    
    RULES_PATH = File.expand_path(File.join(RAILS_ROOT, '/app/rules'))
    @rule_classes = nil
    @rule_groups = nil
        
    class << self
      def discover!
        @rule_classes = []
        @rule_groups = {}
        
        Dir.glob("#{ RULES_PATH }/**/*.rb").each do |rule| 
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
    
      def rule_class(rule_class)
        throw Exception.new("RulesEngine::Discovery.discover! required in environment.rb") if @rule_classes.nil?
        @rule_classes.each do |rule|
          return rule if rule.rule_class == rule_class
        end
        nil
      end
    end
  end
end

