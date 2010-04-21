# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rules_engine}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Douglas"]
  s.date = %q{2010-04-21}
  s.description = %q{Rules engine}
  s.email = %q{dougo.chris@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "VERSION",
     "init.rb",
     "lib/rules_engine.rb",
     "lib/rules_engine/cache.rb",
     "lib/rules_engine/discovery.rb",
     "lib/rules_engine/job_runner.rb",
     "lib/rules_engine/rule.rb",
     "lib/rules_engine/rule_model_loader.rb",
     "lib/rules_engine/rule_outcome.rb",
     "lib/rules_engine_view/alerts.rb",
     "lib/rules_engine_view/boxes.rb",
     "lib/rules_engine_view/buttons.rb",
     "lib/rules_engine_view/defer.rb",
     "lib/rules_engine_view/form_builder.rb",
     "lib/rules_engine_view/form_fields.rb",
     "lib/rules_engine_view/form_styles.rb",
     "lib/rules_engine_view/navigate.rb",
     "rails_generators/manifests/rules_engine.rb",
     "rails_generators/manifests/rules_engine.yml",
     "rails_generators/manifests/rules_engine_complex.rb",
     "rails_generators/manifests/rules_engine_complex.yml",
     "rails_generators/manifests/rules_engine_simple.rb",
     "rails_generators/manifests/rules_engine_simple.yml",
     "rails_generators/manifests/rules_engine_template.rb",
     "rails_generators/rules_engine_complex_generator.rb",
     "rails_generators/rules_engine_generator.rb",
     "rails_generators/rules_engine_simple_generator.rb",
     "rails_generators/templates/app/controllers/re_jobs_controller.rb",
     "rails_generators/templates/app/controllers/re_pipeline_jobs_controller.rb",
     "rails_generators/templates/app/controllers/re_pipelines_controller.rb",
     "rails_generators/templates/app/controllers/re_rules_controller.rb",
     "rails_generators/templates/app/helpers/re_pipeline_helper.rb",
     "rails_generators/templates/app/models/re_job.rb",
     "rails_generators/templates/app/models/re_job_audit.rb",
     "rails_generators/templates/app/models/re_pipeline.rb",
     "rails_generators/templates/app/models/re_pipeline_activated.rb",
     "rails_generators/templates/app/models/re_pipeline_activated_observer.rb",
     "rails_generators/templates/app/models/re_pipeline_base.rb",
     "rails_generators/templates/app/models/re_rule.rb",
     "rails_generators/templates/app/models/re_rule_outcome.rb",
     "rails_generators/templates/app/rules/complex.rb",
     "rails_generators/templates/app/rules/simple.rb",
     "rails_generators/templates/app/rules/template.rb",
     "rails_generators/templates/app/views/layouts/rules_engine.html.erb",
     "rails_generators/templates/app/views/re_jobs/_empty.html.erb",
     "rails_generators/templates/app/views/re_jobs/_index.html.erb",
     "rails_generators/templates/app/views/re_jobs/_show.html.erb",
     "rails_generators/templates/app/views/re_jobs/index.html.erb",
     "rails_generators/templates/app/views/re_jobs/index.js.erb",
     "rails_generators/templates/app/views/re_jobs/show.html.erb",
     "rails_generators/templates/app/views/re_jobs/show.js.erb",
     "rails_generators/templates/app/views/re_pipeline_jobs/_empty.html.erb",
     "rails_generators/templates/app/views/re_pipeline_jobs/_index.html.erb",
     "rails_generators/templates/app/views/re_pipeline_jobs/index.html.erb",
     "rails_generators/templates/app/views/re_pipeline_jobs/index.js.erb",
     "rails_generators/templates/app/views/re_pipelines/_change.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_change_actions.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_confirm.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_edit.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_empty.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_index.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_new.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_show.html.erb",
     "rails_generators/templates/app/views/re_pipelines/_show_actions.html.erb",
     "rails_generators/templates/app/views/re_pipelines/change.html.erb",
     "rails_generators/templates/app/views/re_pipelines/create.js.erb",
     "rails_generators/templates/app/views/re_pipelines/edit.html.erb",
     "rails_generators/templates/app/views/re_pipelines/edit.js.erb",
     "rails_generators/templates/app/views/re_pipelines/index.html.erb",
     "rails_generators/templates/app/views/re_pipelines/new.html.erb",
     "rails_generators/templates/app/views/re_pipelines/new.js.erb",
     "rails_generators/templates/app/views/re_pipelines/show.html.erb",
     "rails_generators/templates/app/views/re_pipelines/template.html.erb",
     "rails_generators/templates/app/views/re_pipelines/update.js.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_edit.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_help.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_new.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_pipeline.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_script.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_title.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_word.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/complex/_words.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/simple/_edit.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/simple/_help.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/simple/_new.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/template/_edit.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/template/_help.html.erb",
     "rails_generators/templates/app/views/re_rule_definitions/template/_new.html.erb",
     "rails_generators/templates/app/views/re_rules/_change.html.erb",
     "rails_generators/templates/app/views/re_rules/_edit.html.erb",
     "rails_generators/templates/app/views/re_rules/_empty.html.erb",
     "rails_generators/templates/app/views/re_rules/_empty.js.erb",
     "rails_generators/templates/app/views/re_rules/_error.html.erb",
     "rails_generators/templates/app/views/re_rules/_help.html.erb",
     "rails_generators/templates/app/views/re_rules/_index.html.erb",
     "rails_generators/templates/app/views/re_rules/_menu.html.erb",
     "rails_generators/templates/app/views/re_rules/_new.html.erb",
     "rails_generators/templates/app/views/re_rules/_show.html.erb",
     "rails_generators/templates/app/views/re_rules/destroy.js.erb",
     "rails_generators/templates/app/views/re_rules/edit.html.erb",
     "rails_generators/templates/app/views/re_rules/edit.js.erb",
     "rails_generators/templates/app/views/re_rules/error.html.erb",
     "rails_generators/templates/app/views/re_rules/error.js.erb",
     "rails_generators/templates/app/views/re_rules/help.html.erb",
     "rails_generators/templates/app/views/re_rules/help.js.erb",
     "rails_generators/templates/app/views/re_rules/new.html.erb",
     "rails_generators/templates/app/views/re_rules/new.js.erb",
     "rails_generators/templates/app/views/re_rules/update.js.erb",
     "rails_generators/templates/db/migrate/20100308225008_create_re_pipelines.rb",
     "rails_generators/templates/doc/README.rules_engine",
     "rails_generators/templates/doc/README.rules_engine_view",
     "rails_generators/templates/lib/tasks/re_runner.rake",
     "rails_generators/templates/public/images/loadingAnimation.gif",
     "rails_generators/templates/public/images/re_job/error-14.png",
     "rails_generators/templates/public/images/re_job/error-18.png",
     "rails_generators/templates/public/images/re_job/error-25.png",
     "rails_generators/templates/public/images/re_job/error-48.png",
     "rails_generators/templates/public/images/re_job/goto-16.png",
     "rails_generators/templates/public/images/re_job/info-14.png",
     "rails_generators/templates/public/images/re_job/info-18.png",
     "rails_generators/templates/public/images/re_job/info-25.png",
     "rails_generators/templates/public/images/re_job/info-48.png",
     "rails_generators/templates/public/images/re_job/list-14.png",
     "rails_generators/templates/public/images/re_job/list-18.png",
     "rails_generators/templates/public/images/re_job/list-25.png",
     "rails_generators/templates/public/images/re_job/list-48.png",
     "rails_generators/templates/public/images/re_job/loadingAnimation.gif",
     "rails_generators/templates/public/images/re_job/next-disabled-14.png",
     "rails_generators/templates/public/images/re_job/next-disabled-18.png",
     "rails_generators/templates/public/images/re_job/next-disabled-25.png",
     "rails_generators/templates/public/images/re_job/next-disabled-48.png",
     "rails_generators/templates/public/images/re_job/next-enabled-14.png",
     "rails_generators/templates/public/images/re_job/next-enabled-18.png",
     "rails_generators/templates/public/images/re_job/next-enabled-25.png",
     "rails_generators/templates/public/images/re_job/next-enabled-48.png",
     "rails_generators/templates/public/images/re_job/prev-disabled-14.png",
     "rails_generators/templates/public/images/re_job/prev-disabled-18.png",
     "rails_generators/templates/public/images/re_job/prev-disabled-25.png",
     "rails_generators/templates/public/images/re_job/prev-disabled-48.png",
     "rails_generators/templates/public/images/re_job/prev-enabled-14.png",
     "rails_generators/templates/public/images/re_job/prev-enabled-18.png",
     "rails_generators/templates/public/images/re_job/prev-enabled-25.png",
     "rails_generators/templates/public/images/re_job/prev-enabled-48.png",
     "rails_generators/templates/public/images/re_job/success-14.png",
     "rails_generators/templates/public/images/re_job/success-18.png",
     "rails_generators/templates/public/images/re_job/success-25.png",
     "rails_generators/templates/public/images/re_job/success-48.png",
     "rails_generators/templates/public/images/re_pipeline/__destroy-14.png",
     "rails_generators/templates/public/images/re_pipeline/__destroy-18.png",
     "rails_generators/templates/public/images/re_pipeline/__destroy-25.png",
     "rails_generators/templates/public/images/re_pipeline/__destroy-48.png",
     "rails_generators/templates/public/images/re_pipeline/activate-14.png",
     "rails_generators/templates/public/images/re_pipeline/activate-18.png",
     "rails_generators/templates/public/images/re_pipeline/activate-25.png",
     "rails_generators/templates/public/images/re_pipeline/activate-48.png",
     "rails_generators/templates/public/images/re_pipeline/alert-14.png",
     "rails_generators/templates/public/images/re_pipeline/alert-18.png",
     "rails_generators/templates/public/images/re_pipeline/alert-25.png",
     "rails_generators/templates/public/images/re_pipeline/alert-48.png",
     "rails_generators/templates/public/images/re_pipeline/change-14.png",
     "rails_generators/templates/public/images/re_pipeline/change-18.png",
     "rails_generators/templates/public/images/re_pipeline/change-25.png",
     "rails_generators/templates/public/images/re_pipeline/change-48.png",
     "rails_generators/templates/public/images/re_pipeline/changed-14.png",
     "rails_generators/templates/public/images/re_pipeline/changed-18.png",
     "rails_generators/templates/public/images/re_pipeline/changed-25.png",
     "rails_generators/templates/public/images/re_pipeline/changed-48.png",
     "rails_generators/templates/public/images/re_pipeline/current-14.png",
     "rails_generators/templates/public/images/re_pipeline/current-18.png",
     "rails_generators/templates/public/images/re_pipeline/current-25.png",
     "rails_generators/templates/public/images/re_pipeline/current-48.png",
     "rails_generators/templates/public/images/re_pipeline/deactivate-14.png",
     "rails_generators/templates/public/images/re_pipeline/deactivate-18.png",
     "rails_generators/templates/public/images/re_pipeline/deactivate-25.png",
     "rails_generators/templates/public/images/re_pipeline/deactivate-48.png",
     "rails_generators/templates/public/images/re_pipeline/destroy-14.png",
     "rails_generators/templates/public/images/re_pipeline/destroy-18.png",
     "rails_generators/templates/public/images/re_pipeline/destroy-25.png",
     "rails_generators/templates/public/images/re_pipeline/destroy-48.png",
     "rails_generators/templates/public/images/re_pipeline/draft-14.png",
     "rails_generators/templates/public/images/re_pipeline/draft-18.png",
     "rails_generators/templates/public/images/re_pipeline/draft-25.png",
     "rails_generators/templates/public/images/re_pipeline/draft-48.png",
     "rails_generators/templates/public/images/re_pipeline/edit-14.png",
     "rails_generators/templates/public/images/re_pipeline/edit-18.png",
     "rails_generators/templates/public/images/re_pipeline/edit-25.png",
     "rails_generators/templates/public/images/re_pipeline/edit-48.png",
     "rails_generators/templates/public/images/re_pipeline/list-14.png",
     "rails_generators/templates/public/images/re_pipeline/list-18.png",
     "rails_generators/templates/public/images/re_pipeline/list-25.png",
     "rails_generators/templates/public/images/re_pipeline/list-48.png",
     "rails_generators/templates/public/images/re_pipeline/list-down.png",
     "rails_generators/templates/public/images/re_pipeline/list-right.png",
     "rails_generators/templates/public/images/re_pipeline/new-14.png",
     "rails_generators/templates/public/images/re_pipeline/new-18.png",
     "rails_generators/templates/public/images/re_pipeline/new-25.png",
     "rails_generators/templates/public/images/re_pipeline/new-48.png",
     "rails_generators/templates/public/images/re_pipeline/revert-14.png",
     "rails_generators/templates/public/images/re_pipeline/revert-18.png",
     "rails_generators/templates/public/images/re_pipeline/revert-25.png",
     "rails_generators/templates/public/images/re_pipeline/revert-48.png",
     "rails_generators/templates/public/images/re_pipeline/show-14.png",
     "rails_generators/templates/public/images/re_pipeline/show-18.png",
     "rails_generators/templates/public/images/re_pipeline/show-25.png",
     "rails_generators/templates/public/images/re_pipeline/show-48.png",
     "rails_generators/templates/public/images/re_pipeline/verify-14.png",
     "rails_generators/templates/public/images/re_pipeline/verify-18.png",
     "rails_generators/templates/public/images/re_pipeline/verify-25.png",
     "rails_generators/templates/public/images/re_pipeline/verify-48.png",
     "rails_generators/templates/public/images/re_rule/__destroy-14.png",
     "rails_generators/templates/public/images/re_rule/__destroy-18.png",
     "rails_generators/templates/public/images/re_rule/__destroy-25.png",
     "rails_generators/templates/public/images/re_rule/__destroy-48.png",
     "rails_generators/templates/public/images/re_rule/destroy-14.png",
     "rails_generators/templates/public/images/re_rule/destroy-18.png",
     "rails_generators/templates/public/images/re_rule/destroy-25.png",
     "rails_generators/templates/public/images/re_rule/destroy-48.png",
     "rails_generators/templates/public/images/re_rule/edit-14.png",
     "rails_generators/templates/public/images/re_rule/edit-18.png",
     "rails_generators/templates/public/images/re_rule/edit-25.png",
     "rails_generators/templates/public/images/re_rule/edit-48.png",
     "rails_generators/templates/public/images/re_rule/goto-pipeline-14.png",
     "rails_generators/templates/public/images/re_rule/goto-pipeline-18.png",
     "rails_generators/templates/public/images/re_rule/move-down-14.png",
     "rails_generators/templates/public/images/re_rule/move-down-18.png",
     "rails_generators/templates/public/images/re_rule/move-down-25.png",
     "rails_generators/templates/public/images/re_rule/move-down-48.png",
     "rails_generators/templates/public/images/re_rule/move-down-off-14.png",
     "rails_generators/templates/public/images/re_rule/move-down-off-18.png",
     "rails_generators/templates/public/images/re_rule/move-down-off-25.png",
     "rails_generators/templates/public/images/re_rule/move-down-off-48.png",
     "rails_generators/templates/public/images/re_rule/move-up-14.png",
     "rails_generators/templates/public/images/re_rule/move-up-18.png",
     "rails_generators/templates/public/images/re_rule/move-up-25.png",
     "rails_generators/templates/public/images/re_rule/move-up-48.png",
     "rails_generators/templates/public/images/re_rule/move-up-off-14.png",
     "rails_generators/templates/public/images/re_rule/move-up-off-18.png",
     "rails_generators/templates/public/images/re_rule/move-up-off-25.png",
     "rails_generators/templates/public/images/re_rule/move-up-off-48.png",
     "rails_generators/templates/public/images/re_rule/next-change-14.png",
     "rails_generators/templates/public/images/re_rule/next-change-18.png",
     "rails_generators/templates/public/images/re_rule/next-change-25.png",
     "rails_generators/templates/public/images/re_rule/next-change-48.png",
     "rails_generators/templates/public/images/re_rule/next-show-14.png",
     "rails_generators/templates/public/images/re_rule/next-show-18.png",
     "rails_generators/templates/public/images/re_rule/next-show-25.png",
     "rails_generators/templates/public/images/re_rule/next-show-48.png",
     "rails_generators/templates/public/images/re_rule/stop-failure-14.png",
     "rails_generators/templates/public/images/re_rule/stop-failure-18.png",
     "rails_generators/templates/public/images/re_rule/stop-failure-25.png",
     "rails_generators/templates/public/images/re_rule/stop-failure-48.png",
     "rails_generators/templates/public/images/re_rule/stop-success-14.png",
     "rails_generators/templates/public/images/re_rule/stop-success-18.png",
     "rails_generators/templates/public/images/re_rule/stop-success-25.png",
     "rails_generators/templates/public/images/re_rule/stop-success-48.png",
     "rails_generators/templates/public/images/re_rule/valid-14.png",
     "rails_generators/templates/public/images/re_rule/valid-18.png",
     "rails_generators/templates/public/images/re_rule/valid-25.png",
     "rails_generators/templates/public/images/re_rule/valid-48.png",
     "rails_generators/templates/public/images/re_rule/verify-14.png",
     "rails_generators/templates/public/images/re_rule/verify-18.png",
     "rails_generators/templates/public/images/re_rule/verify-25.png",
     "rails_generators/templates/public/images/re_rule/verify-48.png",
     "rails_generators/templates/public/images/re_rule_class/add-14.png",
     "rails_generators/templates/public/images/re_rule_class/add-18.png",
     "rails_generators/templates/public/images/re_rule_class/add-25.png",
     "rails_generators/templates/public/images/re_rule_class/add-48.png",
     "rails_generators/templates/public/images/re_rule_class/help-14.png",
     "rails_generators/templates/public/images/re_rule_class/help-18.png",
     "rails_generators/templates/public/images/re_rule_class/help-25.png",
     "rails_generators/templates/public/images/re_rule_class/help-48.png",
     "rails_generators/templates/public/images/re_rule_class/list-down.png",
     "rails_generators/templates/public/images/re_rule_class/list-right.png",
     "rails_generators/templates/public/images/re_rule_class/new-14.png",
     "rails_generators/templates/public/images/re_rule_class/new-18.png",
     "rails_generators/templates/public/images/re_rule_class/new-25.png",
     "rails_generators/templates/public/images/re_rule_class/new-48.png",
     "rails_generators/templates/public/javascripts/jquery-1.3.2.min.js",
     "rails_generators/templates/public/javascripts/jquery.autocomplete.pack.js",
     "rails_generators/templates/public/javascripts/jquery.blockUI.js",
     "rails_generators/templates/public/javascripts/re_jobs.js",
     "rails_generators/templates/public/javascripts/re_pipeline_change.js",
     "rails_generators/templates/public/javascripts/re_pipeline_index.js",
     "rails_generators/templates/public/javascripts/re_pipeline_jobs.js",
     "rails_generators/templates/public/javascripts/re_pipeline_new.js",
     "rails_generators/templates/public/javascripts/re_view.js",
     "rails_generators/templates/public/javascripts/thickbox.js",
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
     "rails_generators/templates/public/stylesheets/jquery.autocomplete.css",
     "rails_generators/templates/public/stylesheets/macFFBgHack.png",
     "rails_generators/templates/public/stylesheets/re_pipeline.css",
     "rails_generators/templates/public/stylesheets/re_pipeline/accept.png",
     "rails_generators/templates/public/stylesheets/re_pipeline/exclamation.png",
     "rails_generators/templates/public/stylesheets/re_view.css",
     "rails_generators/templates/public/stylesheets/re_view_box.css",
     "rails_generators/templates/public/stylesheets/re_view_box/accept.png",
     "rails_generators/templates/public/stylesheets/re_view_box/exclamation.png",
     "rails_generators/templates/public/stylesheets/re_view_box/shadowbox.jpg",
     "rails_generators/templates/public/stylesheets/re_view_box/shadowbox.png",
     "rails_generators/templates/public/stylesheets/re_view_box/whitebox.jpg",
     "rails_generators/templates/public/stylesheets/re_view_button.css",
     "rails_generators/templates/public/stylesheets/re_view_button/checked-off.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/checked-on.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/icon-add.png",
     "rails_generators/templates/public/stylesheets/re_view_button/icon-delete.png",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-blue-left.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-blue-right.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-gray-left.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-gray-right.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-green-left.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-green-right.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-orange-left.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-orange-right.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-red-left.gif",
     "rails_generators/templates/public/stylesheets/re_view_button/oval-red-right.gif",
     "rails_generators/templates/public/stylesheets/re_view_error.css",
     "rails_generators/templates/public/stylesheets/re_view_form.css",
     "rails_generators/templates/public/stylesheets/re_view_navigate.css",
     "rails_generators/templates/public/stylesheets/re_view_navigate/add-new-icon.png",
     "rails_generators/templates/public/stylesheets/re_view_navigate/breadcrumb.png",
     "rails_generators/templates/public/stylesheets/re_view_navigate/delete-icon.png",
     "rails_generators/templates/public/stylesheets/re_view_navigate/icon-add.png",
     "rails_generators/templates/public/stylesheets/re_view_navigate/icon-delete.png",
     "rails_generators/templates/public/stylesheets/re_view_navigate/subnav-bg.jpg",
     "rails_generators/templates/public/stylesheets/re_view_navigate/subnavitems-bg.gif",
     "rails_generators/templates/public/stylesheets/re_view_navigate/subnavitems-bg.jpg",
     "rails_generators/templates/public/stylesheets/re_view_table.css",
     "rails_generators/templates/public/stylesheets/thickbox.css",
     "rails_generators/templates/spec/controllers/re_pipelines_controller_spec.rb",
     "rails_generators/templates/spec/models/re_job_audit_spec.rb",
     "rails_generators/templates/spec/models/re_job_spec.rb",
     "rails_generators/templates/spec/models/re_pipeline_activated_spec.rb",
     "rails_generators/templates/spec/models/re_pipeline_base_spec.rb",
     "rails_generators/templates/spec/models/re_pipeline_spec.rb",
     "rails_generators/templates/spec/models/re_rule_outcome_spec.rb",
     "rails_generators/templates/spec/models/re_rule_spec.rb",
     "rails_generators/templates/spec/support/blueprint_re_pipelines.rb",
     "spec/railsenv/app/controllers/application_controller.rb",
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
     "spec/railsenv/log/test.log",
     "spec/rcov.opts",
     "spec/rules_engine/rule_model_loader_spec.rb",
     "spec/rules_engine/rules_engine_spec.rb",
     "spec/rules_engine_view/alerts_spec.rb",
     "spec/rules_engine_view/boxes_spec.rb",
     "spec/rules_engine_view/buttons_spec.rb",
     "spec/rules_engine_view/defer_spec.rb",
     "spec/rules_engine_view/form_builder_fields_spec.rb",
     "spec/rules_engine_view/form_builder_spec.rb",
     "spec/rules_engine_view/form_fields_spec.rb",
     "spec/rules_engine_view/form_styles_spec.rb",
     "spec/rules_engine_view/navigate_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "tasks/rspec.rake"
  ]
  s.homepage = %q{http://dougochris.github.com}
  s.post_install_message = %q{
      *** RUN script/generate rules_engine
    }
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Rules engine}
  s.test_files = [
    "spec/railsenv/app/controllers/application_controller.rb",
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
     "spec/rules_engine/rule_model_loader_spec.rb",
     "spec/rules_engine/rules_engine_spec.rb",
     "spec/rules_engine_view/alerts_spec.rb",
     "spec/rules_engine_view/boxes_spec.rb",
     "spec/rules_engine_view/buttons_spec.rb",
     "spec/rules_engine_view/defer_spec.rb",
     "spec/rules_engine_view/form_builder_fields_spec.rb",
     "spec/rules_engine_view/form_builder_spec.rb",
     "spec/rules_engine_view/form_fields_spec.rb",
     "spec/rules_engine_view/form_styles_spec.rb",
     "spec/rules_engine_view/navigate_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

