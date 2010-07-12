require 'rules_engine_view'
RulesEngine::Discovery.discover!

RulesEngine::Plan.publisher = :db_publisher
RulesEngine::Process.runner = :db_process_runner
RulesEngine::Process.auditor = :db_process_auditor
RulesEngine::Process.auditor.audit_level = RulesEngine::Process::AUDIT_SUCCESS
