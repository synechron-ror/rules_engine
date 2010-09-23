RulesEngine::Discovery.discover!

RulesEngine::Publish.publisher = :db_publisher
RulesEngine::Process.runner = :db_runner
RulesEngine::Process.auditor = :db_auditor
RulesEngine::Process.auditor.audit_level = RulesEngine::Process::AUDIT_INFO

RulesEngineView::Defer.prefix_breadcrumbs = nil