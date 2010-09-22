module RulesEngine
  module RouteMatcher
    class Matcher
      attr_reader :route_params, :with_params
      def initialize(params = {})
        @route_params = params
        @with_params = params.map{|key, value| ":#{key} => #{value}"}.join(' ')
      end  
    end
    
    def with_route_params(params, &block)
      @route_matcher = RulesEngine::RouteMatcher::Matcher.new(params)
      yield
      @route_matcher = nil
    end
    
    def match_route html_method, controller, routes
      matcher = @route_matcher || RulesEngine::RouteMatcher::Matcher.new()

      routes.each do |method, path| 
        it "routes #{html_method} #{path} to #{controller}##{method} #{matcher.with_params}" do
          { html_method => "#{path}" }.should route_to(
            {:controller => controller.to_s,
            :action => method.to_s }.merge(matcher.route_params)
          )
        end
      end

    end    
  end
end