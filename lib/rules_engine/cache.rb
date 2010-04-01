module RulesEngine
  module Cache
    # Configuration examples (MemoryStore is the default):
    #
    #   RulesEngine::SelectorCache.cache_store = :memory_store
    #   RulesEngine::SelectorCache.cache_store = :file_store, "/path/to/cache/directory"
    #   RulesEngine::SelectorCache.cache_store = :drb_store, "druby://localhost:9192"
    #   RulesEngine::SelectorCache.cache_store = :mem_cache_store, "localhost"
    #   RulesEngine::SelectorCache.cache_store = MyOwnStore.new("parameter")

    class << self
      def perform_caching?
        !@cache_store.nil? 
      end

      def cache_store=(store_option)
        @cache_store = ActiveSupport::Cache.lookup_store(store_option)
      end

      def cache_store
        @cache_store 
      end      
    end
    
  end
end