module RulesEngine
  module RouteMatcher
    class Matcher
      attr_reader :route_controller, :route_params, :with_params
      def initialize(route_controller, params = {})
        @route_controller = route_controller.to_s
        @route_params = params
        @with_params = params.map{|key, value| ":#{key} => #{value}"}.join(' ')
      end  
    end
    
    def match_controller(route_controller, params = {}, &block)
      @route_matcher = RulesEngine::RouteMatcher::Matcher.new(route_controller, params)
      yield
      @route_matcher = nil
    end
    
    def with_route(html_method, routes)
      matcher = @route_matcher

      routes.each do |path, method| 
        it "routes #{html_method} #{path} to #{matcher.route_controller}##{method} #{matcher.with_params}" do
          { html_method => "#{path}" }.should route_to(
            {:controller => matcher.route_controller,
            :action => method.to_s }.merge(matcher.route_params)
          )
        end
      end
    end    
  end
end