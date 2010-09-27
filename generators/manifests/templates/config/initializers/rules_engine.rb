RulesEngine::Discovery.discover!

RulesEngine::Publish.publisher = :db_publisher
RulesEngine::Process.runner = :db_runner
RulesEngine::Process.auditor = :db_auditor
RulesEngine::Process.auditor.audit_level = RulesEngine::Process::AUDIT_INFO

RulesEngine::Cache.cache_store = nil
# RulesEngine::Cache.cache_store = :mem_cache_store, "localhost:11210"
# RulesEngine::Cache.cache_store = :memory_store
# RulesEngine::Cache.cache_store = :file_store, "/path/to/cache/directory"
# RulesEngine::Cache.cache_store = :drb_store, "druby://localhost:9192"
# RulesEngine::Cache.cache_store = :mem_cache_store, "localhost"
# RulesEngine::Cache.cache_store = MyOwnStore.new("parameter")

RulesEngineView::Config.layout = nil
RulesEngineView::Config.prefix_breadcrumbs = nil