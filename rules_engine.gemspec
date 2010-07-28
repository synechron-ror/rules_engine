# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rules_engine}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Douglas"]
  s.date = %q{2010-07-28}
  s.description = %q{Rules engine}
  s.email = %q{dougo.chris@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    "LICENSE",
     "VERSION",
     "init.rb",
     "lib/rules_engine.rb",
     "lib/rules_engine/cache.rb",
     "lib/rules_engine/discovery.rb",
     "lib/rules_engine/process/auditor.rb",
     "lib/rules_engine/process/auditor/db_auditor.rb",
     "lib/rules_engine/process/runner.rb",
     "lib/rules_engine/process/runner/db_runner.rb",
     "lib/rules_engine/publish/publisher.rb",
     "lib/rules_engine/publish/publisher/db_publisher.rb",
     "lib/rules_engine/rule/definition.rb",
     "lib/rules_engine/rule/outcome.rb",
     "lib/rules_engine_view.rb",
     "lib/rules_engine_view/alerts.rb",
     "lib/rules_engine_view/boxes.rb",
     "lib/rules_engine_view/buttons.rb",
     "lib/rules_engine_view/defer.rb",
     "lib/rules_engine_view/form_builder.rb",
     "lib/rules_engine_view/form_fields.rb",
     "lib/rules_engine_view/form_styles.rb",
     "lib/rules_engine_view/model_loader.rb",
     "lib/rules_engine_view/navigate.rb",
     "rails_generators/manifests/complex.rb",
     "rails_generators/manifests/complex.yml",
     "rails_generators/manifests/rules_engine.rb",
     "rails_generators/manifests/rules_engine.yml",
     "rails_generators/manifests/simple.rb",
     "rails_generators/manifests/simple.yml",
     "rails_generators/rules_engine_generator.rb",
     "rails_generators/templates/app/controllers/re_plan_workflow_rules_controller.rb",
     "rails_generators/templates/app/controllers/re_plan_workflows_controller.rb",
     "rails_generators/templates/app/controllers/re_plans_controller.rb",
     "rails_generators/templates/app/controllers/re_processes_controller.rb",
     "rails_generators/templates/app/controllers/re_publications_controller.rb",
     "rails_generators/templates/app/controllers/re_workflow_rules_controller.rb",
     "rails_generators/templates/app/controllers/re_workflows_controller.rb",
     "rails_generators/templates/app/helpers/rules_engine_helper.rb",
     "rails_generators/templates/app/models/re_plan.rb",
     "rails_generators/templates/app/models/re_plan_workflow.rb",
     "rails_generators/templates/app/models/re_rule.rb",
     "rails_generators/templates/app/models/re_rule_expected_outcome.rb",
     "rails_generators/templates/app/models/re_workflow.rb",
     "rails_generators/templates/app/rules/complex.rb",
     "rails_generators/templates/app/rules/simple.rb",
     "rails_generators/templates/app/views/layouts/rules_engine.html.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/edit.html.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/edit.js.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/error.html.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/error.js.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/help.html.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/help.js.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/new.html.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/new.js.erb",
     "rails_generators/templates/app/views/re_plan_workflow_rules/update.js.erb",
     "rails_generators/templates/app/views/re_plan_workflows/change.html.erb",
     "rails_generators/templates/app/views/re_plan_workflows/edit.html.erb",
     "rails_generators/templates/app/views/re_plan_workflows/edit.js.erb",
     "rails_generators/templates/app/views/re_plan_workflows/new.html.erb",
     "rails_generators/templates/app/views/re_plan_workflows/new.js.erb",
     "rails_generators/templates/app/views/re_plan_workflows/show.html.erb",
     "rails_generators/templates/app/views/re_plan_workflows/update.js.erb",
     "rails_generators/templates/app/views/re_plans/_change.html.erb",
     "rails_generators/templates/app/views/re_plans/_edit.html.erb",
     "rails_generators/templates/app/views/re_plans/_empty.html.erb",
     "rails_generators/templates/app/views/re_plans/_index.html.erb",
     "rails_generators/templates/app/views/re_plans/_menu.html.erb",
     "rails_generators/templates/app/views/re_plans/_new.html.erb",
     "rails_generators/templates/app/views/re_plans/_preview.html.erb",
     "rails_generators/templates/app/views/re_plans/_show.html.erb",
     "rails_generators/templates/app/views/re_plans/_workflow_change.html.erb",
     "rails_generators/templates/app/views/re_plans/_workflow_preview.html.erb",
     "rails_generators/templates/app/views/re_plans/_workflow_show.html.erb",
     "rails_generators/templates/app/views/re_plans/change.html.erb",
     "rails_generators/templates/app/views/re_plans/create.js.erb",
     "rails_generators/templates/app/views/re_plans/edit.html.erb",
     "rails_generators/templates/app/views/re_plans/edit.js.erb",
     "rails_generators/templates/app/views/re_plans/index.html.erb",
     "rails_generators/templates/app/views/re_plans/index.js.erb",
     "rails_generators/templates/app/views/re_plans/new.html.erb",
     "rails_generators/templates/app/views/re_plans/new.js.erb",
     "rails_generators/templates/app/views/re_plans/preview.html.erb",
     "rails_generators/templates/app/views/re_plans/preview.js.erb",
     "rails_generators/templates/app/views/re_plans/re_process.html.erb",
     "rails_generators/templates/app/views/re_plans/re_process.js.erb",
     "rails_generators/templates/app/views/re_plans/show.html.erb",
     "rails_generators/templates/app/views/re_plans/template.html.erb",
     "rails_generators/templates/app/views/re_plans/update.js.erb",
     "rails_generators/templates/app/views/re_processes/_index_prepare.html.erb",
     "rails_generators/templates/app/views/re_processes/_index_update.html.erb",
     "rails_generators/templates/app/views/re_processes/_show.html.erb",
     "rails_generators/templates/app/views/re_processes/index.html.erb",
     "rails_generators/templates/app/views/re_processes/index.js.erb",
     "rails_generators/templates/app/views/re_processes/show.html.erb",
     "rails_generators/templates/app/views/re_processes/show.js.erb",
     "rails_generators/templates/app/views/re_publications/_show_prepare.html.erb",
     "rails_generators/templates/app/views/re_publications/_show_update.html.erb",
     "rails_generators/templates/app/views/re_publications/show.html.erb",
     "rails_generators/templates/app/views/re_publications/show.js.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_edit.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_form.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_form_word.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_help.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_new.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/simple/_edit.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/simple/_form.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/simple/_help.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/simple/_new.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/_edit.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/_error.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/_help.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/_new.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/edit.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/edit.js.erb",
     "rails_generators/templates/app/views/re_workflow_rules/error.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/error.js.erb",
     "rails_generators/templates/app/views/re_workflow_rules/help.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/help.js.erb",
     "rails_generators/templates/app/views/re_workflow_rules/new.html.erb",
     "rails_generators/templates/app/views/re_workflow_rules/new.js.erb",
     "rails_generators/templates/app/views/re_workflow_rules/update.js.erb",
     "rails_generators/templates/app/views/re_workflows/_add_prepare.html.erb",
     "rails_generators/templates/app/views/re_workflows/_add_update.html.erb",
     "rails_generators/templates/app/views/re_workflows/_edit.html.erb",
     "rails_generators/templates/app/views/re_workflows/_empty.html.erb",
     "rails_generators/templates/app/views/re_workflows/_index.html.erb",
     "rails_generators/templates/app/views/re_workflows/_menu.html.erb",
     "rails_generators/templates/app/views/re_workflows/_new.html.erb",
     "rails_generators/templates/app/views/re_workflows/_plan_prepare.html.erb",
     "rails_generators/templates/app/views/re_workflows/_plan_update.html.erb",
     "rails_generators/templates/app/views/re_workflows/_preview.html.erb",
     "rails_generators/templates/app/views/re_workflows/_rule_change.html.erb",
     "rails_generators/templates/app/views/re_workflows/_rule_empty.html.erb",
     "rails_generators/templates/app/views/re_workflows/_rule_preview.html.erb",
     "rails_generators/templates/app/views/re_workflows/_rule_show.html.erb",
     "rails_generators/templates/app/views/re_workflows/_show.html.erb",
     "rails_generators/templates/app/views/re_workflows/add.html.erb",
     "rails_generators/templates/app/views/re_workflows/add.js.erb",
     "rails_generators/templates/app/views/re_workflows/change.html.erb",
     "rails_generators/templates/app/views/re_workflows/create.js.erb",
     "rails_generators/templates/app/views/re_workflows/edit.html.erb",
     "rails_generators/templates/app/views/re_workflows/edit.js.erb",
     "rails_generators/templates/app/views/re_workflows/index.html.erb",
     "rails_generators/templates/app/views/re_workflows/new.html.erb",
     "rails_generators/templates/app/views/re_workflows/new.js.erb",
     "rails_generators/templates/app/views/re_workflows/plan.html.erb",
     "rails_generators/templates/app/views/re_workflows/plan.js.erb",
     "rails_generators/templates/app/views/re_workflows/preview.html.erb",
     "rails_generators/templates/app/views/re_workflows/preview.js.erb",
     "rails_generators/templates/app/views/re_workflows/show.html.erb",
     "rails_generators/templates/app/views/re_workflows/update.js.erb",
     "rails_generators/templates/config/initializers/rules_engine.rb",
     "rails_generators/templates/db/migrate/20100308225008_create_rules_engine.rb",
     "rails_generators/templates/doc/README.rules_engine",
     "rails_generators/templates/doc/README.rules_engine_features",
     "rails_generators/templates/doc/README.rules_engine_view",
     "rails_generators/templates/features/re_pipeline/lookup.feature",
     "rails_generators/templates/features/step_definitions/common/re_debug_steps.rb",
     "rails_generators/templates/features/step_definitions/common/re_error_steps.rb",
     "rails_generators/templates/features/step_definitions/common/re_form_steps.rb",
     "rails_generators/templates/features/step_definitions/common/re_model_steps.rb",
     "rails_generators/templates/features/step_definitions/common/re_user_steps.rb",
     "rails_generators/templates/features/step_definitions/common/re_view_steps.rb",
     "rails_generators/templates/features/support/rules_engine.rb",
     "rails_generators/templates/lib/tasks/rules_engine.rake",
     "rails_generators/templates/public/javascripts/jquery-1.4.2.min.js",
     "rails_generators/templates/public/javascripts/jquery.autocomplete.pack.js",
     "rails_generators/templates/public/javascripts/jquery.blockUI.js",
     "rails_generators/templates/public/javascripts/jquery.fancybox-1.3.1.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_plan_change.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_plan_new.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_plan_preview.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_process_index.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_process_show.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_publication_show.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_view.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_workflow_add.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_workflow_change.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_workflow_new.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_workflow_plan.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_workflow_preview.js",
     "rails_generators/templates/public/javascripts/rules_engine/re_workflow_show.js",
     "rails_generators/templates/public/stylesheets/blueprint/ie.css",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/buttons/icons/cross.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/buttons/icons/key.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/buttons/icons/tick.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/buttons/readme.txt",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/buttons/screen.css",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/fancy-type/readme.txt",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/fancy-type/screen.css",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/doc.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/email.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/external.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/feed.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/im.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/pdf.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/visited.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/icons/xls.png",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/readme.txt",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/link-icons/screen.css",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/rtl/readme.txt",
     "rails_generators/templates/public/stylesheets/blueprint/plugins/rtl/screen.css",
     "rails_generators/templates/public/stylesheets/blueprint/print.css",
     "rails_generators/templates/public/stylesheets/blueprint/screen.css",
     "rails_generators/templates/public/stylesheets/blueprint/src/forms.css",
     "rails_generators/templates/public/stylesheets/blueprint/src/grid.css",
     "rails_generators/templates/public/stylesheets/blueprint/src/grid.png",
     "rails_generators/templates/public/stylesheets/blueprint/src/ie.css",
     "rails_generators/templates/public/stylesheets/blueprint/src/print.css",
     "rails_generators/templates/public/stylesheets/blueprint/src/reset.css",
     "rails_generators/templates/public/stylesheets/blueprint/src/typography.css",
     "rails_generators/templates/public/stylesheets/fancybox/blank.gif",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_close.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_loading.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_nav_left.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_nav_right.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_e.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_n.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_ne.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_nw.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_s.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_se.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_sw.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_shadow_w.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_title_left.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_title_main.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_title_over.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancy_title_right.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancybox-x.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancybox-y.png",
     "rails_generators/templates/public/stylesheets/fancybox/fancybox.png",
     "rails_generators/templates/public/stylesheets/fancybox/jquery.fancybox-1.3.1.css",
     "rails_generators/templates/public/stylesheets/jquery.autocomplete.css",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_box/shadowbox.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_box/whitebox.jpg",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/checked-off.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/checked-on.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/icon-add.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/icon-delete.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-blue-left.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-blue-right.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-gray-left.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-gray-right.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-green-left.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-green-right.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-orange-left.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-orange-right.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-red-left.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_button/oval-red-right.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_error/re-alert-close.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/re_view_navigate/breadcrumb.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/list-next-disabled-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/list-next-enabled-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/list-prev-disabled-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/list-prev-enabled-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/loading.gif",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-changed-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-changed-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-draft-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-draft-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-error-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-info-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-published-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-published-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-success-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-valid-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-valid-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-verify-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-verify-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_common/status-verify-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/alert-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/change-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/delete-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/edit-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/list-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/new-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/preview-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/publish-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/revert-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/show-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/title-plural.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_plan/title-single.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_process/error-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_process/info-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_process/list-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_process/success-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_publication/show-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/add-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/alert-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/destroy-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/edit-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/error-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/help-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/help-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/icon-ad-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/move-down-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/move-down-off-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/move-up-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/move-up-off-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/new-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/next-down-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/next-right-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/show-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/start-pipeline-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/stop-failure-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/stop-success-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/title-plural.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_rule/title-single.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/add-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/add-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/add-off-14.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/alert-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/change-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/change-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/delete-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/edit-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/is-default-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/list-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/make-default-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/make-default-off-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/new-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/plan-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/preview-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/remove-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/show-18.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/show-25.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/title-plural.png",
     "rails_generators/templates/public/stylesheets/rules_engine/images/rules_engine/re_workflow/title-single.png",
     "rails_generators/templates/public/stylesheets/rules_engine/screen.css",
     "rails_generators/templates/spec/controllers/re_plans_controller_spec.rb",
     "rails_generators/templates/spec/helpers/rules_engine_helper_spec.rb",
     "rails_generators/templates/spec/lib/rules/complex_spec.rb",
     "rails_generators/templates/spec/lib/rules/simple_spec.rb",
     "rails_generators/templates/spec/models/re_plan_spec.rb",
     "rails_generators/templates/spec/models/re_plan_workflow_spec.rb",
     "rails_generators/templates/spec/models/re_rule_expected_outcome_spec.rb",
     "rails_generators/templates/spec/models/re_rule_spec.rb",
     "rails_generators/templates/spec/models/re_workflow_spec.rb",
     "rails_generators/templates/spec/support/rules_engine_blueprints.rb",
     "rails_generators/templates/spec/support/rules_engine_macros.rb",
     "spec/railsenv/app/controllers/application_controller.rb",
     "spec/railsenv/app/rules/mock_rule.rb",
     "spec/railsenv/config/boot.rb",
     "spec/railsenv/config/database.yml",
     "spec/railsenv/config/environment.rb",
     "spec/railsenv/config/environments/development.rb",
     "spec/railsenv/config/environments/production.rb",
     "spec/railsenv/config/environments/test.rb",
     "spec/railsenv/config/initializers/backtrace_silencers.rb",
     "spec/railsenv/config/initializers/inflections.rb",
     "spec/railsenv/config/initializers/mime_types.rb",
     "spec/railsenv/config/initializers/new_rails_defaults.rb",
     "spec/railsenv/config/initializers/session_store.rb",
     "spec/railsenv/config/locales/en.yml",
     "spec/railsenv/config/routes.rb",
     "spec/railsenv/db/test.sqlite3",
     "spec/railsenv/log/debug.log",
     "spec/railsenv/log/empty.txt",
     "spec/railsenv/log/test.log",
     "spec/rcov.opts",
     "spec/rules_engine/cache_spec.rb",
     "spec/rules_engine/discovery_spec.rb",
     "spec/rules_engine/process/auditor/db_auditor_spec.rb",
     "spec/rules_engine/process/auditor_spec.rb",
     "spec/rules_engine/process/runner/db_runner_spec.rb",
     "spec/rules_engine/process/runner_spec.rb",
     "spec/rules_engine/publish/publisher/db_publisher_spec.rb",
     "spec/rules_engine/publish/publisher_spec.rb",
     "spec/rules_engine/rule/definition_spec.rb",
     "spec/rules_engine_view/alerts_spec.rb",
     "spec/rules_engine_view/boxes_spec.rb",
     "spec/rules_engine_view/buttons_spec.rb",
     "spec/rules_engine_view/defer_spec.rb",
     "spec/rules_engine_view/form_builder_fields_spec.rb",
     "spec/rules_engine_view/form_builder_spec.rb",
     "spec/rules_engine_view/form_fields_spec.rb",
     "spec/rules_engine_view/form_styles_spec.rb",
     "spec/rules_engine_view/model_loader_spec.rb",
     "spec/rules_engine_view/navigate_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "tasks/rspec.rake"
  ]
  s.homepage = %q{http://github.com/dougochris/rules_engine_view}
  s.post_install_message = %q{
      *** RUN script/generate rules_engine
    }
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Rules engine}
  s.test_files = [
    "spec/railsenv/app/controllers/application_controller.rb",
     "spec/railsenv/app/rules/mock_rule.rb",
     "spec/railsenv/config/boot.rb",
     "spec/railsenv/config/environment.rb",
     "spec/railsenv/config/environments/development.rb",
     "spec/railsenv/config/environments/production.rb",
     "spec/railsenv/config/environments/test.rb",
     "spec/railsenv/config/initializers/backtrace_silencers.rb",
     "spec/railsenv/config/initializers/inflections.rb",
     "spec/railsenv/config/initializers/mime_types.rb",
     "spec/railsenv/config/initializers/new_rails_defaults.rb",
     "spec/railsenv/config/initializers/session_store.rb",
     "spec/railsenv/config/routes.rb",
     "spec/rules_engine/cache_spec.rb",
     "spec/rules_engine/discovery_spec.rb",
     "spec/rules_engine/process/auditor/db_auditor_spec.rb",
     "spec/rules_engine/process/auditor_spec.rb",
     "spec/rules_engine/process/runner/db_runner_spec.rb",
     "spec/rules_engine/process/runner_spec.rb",
     "spec/rules_engine/publish/publisher/db_publisher_spec.rb",
     "spec/rules_engine/publish/publisher_spec.rb",
     "spec/rules_engine/rule/definition_spec.rb",
     "spec/rules_engine_view/alerts_spec.rb",
     "spec/rules_engine_view/boxes_spec.rb",
     "spec/rules_engine_view/buttons_spec.rb",
     "spec/rules_engine_view/defer_spec.rb",
     "spec/rules_engine_view/form_builder_fields_spec.rb",
     "spec/rules_engine_view/form_builder_spec.rb",
     "spec/rules_engine_view/form_fields_spec.rb",
     "spec/rules_engine_view/form_styles_spec.rb",
     "spec/rules_engine_view/model_loader_spec.rb",
     "spec/rules_engine_view/navigate_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

