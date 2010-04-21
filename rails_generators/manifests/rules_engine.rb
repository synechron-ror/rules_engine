class RulesEngineManifest
  def self.populate_record(m)

    %w(
      public/stylesheets
      public/stylesheets/re_view_button
      public/stylesheets/blueprint/plugins
      public/images/re_pipeline
      app/views/re_pipelines
      app/views/re_pipeline_jobs
      public/images/re_rule
      public/javascripts
      doc
      public/stylesheets/blueprint/plugins/link-icons/icons
      public/stylesheets/blueprint/plugins/link-icons
      public/stylesheets/blueprint/src
      app/helpers
      app/models
      public/images/re_job
      spec/controllers
      public/stylesheets/blueprint/plugins/fancy-type
      public/stylesheets/blueprint
      lib/tasks
      db/migrate
      public/stylesheets/re_view_box
      public/stylesheets/blueprint/plugins/buttons
      public/stylesheets/blueprint/plugins/rtl
      app/views/re_rules
      app/views/re_jobs
      public/images/re_rule_class
      app/views/layouts
      public/stylesheets/re_view_navigate
      public/stylesheets/blueprint/plugins/buttons/icons
      spec/support
      app/controllers
      spec/models
      public/images
      public/stylesheets/re_pipeline
    ).each do |dirname|
      m.directory dirname
    end

    %w(
      public/stylesheets/re_view_error.css
      app/models/re_rule_outcome.rb
      public/stylesheets/re_view_navigate/icon-delete.png
      public/images/re_rule/move-down-48.png
      spec/models/re_pipeline_spec.rb
      public/images/re_pipeline/revert-14.png
      public/images/re_job/next-enabled-48.png
      public/images/re_pipeline/new-48.png
      public/images/re_rule_class/help-48.png
      public/stylesheets/re_view_table.css
      public/stylesheets/re_view_navigate/breadcrumb.png
      public/images/re_job/prev-enabled-25.png
      app/views/re_rules/_menu.html.erb
      public/images/re_job/success-48.png
      public/images/re_pipeline/__destroy-25.png
      public/images/re_job/list-18.png
      public/images/re_rule/move-down-14.png
      public/images/re_pipeline/deactivate-25.png
      app/views/re_pipelines/_empty.html.erb
      app/views/re_rules/_empty.html.erb
      public/images/re_rule_class/add-25.png
      public/stylesheets/blueprint/src/forms.css
      app/models/re_pipeline.rb
      public/stylesheets/re_view_box/shadowbox.jpg
      public/images/re_pipeline/changed-18.png
      app/views/re_pipelines/edit.html.erb
      public/images/re_pipeline/deactivate-18.png
      public/images/re_rule_class/add-18.png
      public/images/re_rule_class/new-48.png
      public/images/re_pipeline/draft-25.png
      public/images/re_pipeline/new-14.png
      public/stylesheets/re_view_navigate/delete-icon.png
      public/images/re_rule/move-up-off-25.png
      public/images/re_rule/valid-18.png
      public/images/re_job/next-disabled-48.png
      app/views/re_rules/edit.html.erb
      public/images/re_job/info-18.png
      public/images/re_rule/goto-pipeline-18.png
      app/views/re_pipelines/show.html.erb
      public/images/re_pipeline/draft-18.png
      public/stylesheets/thickbox.css
      app/views/re_jobs/_show.html.erb
      public/stylesheets/macFFBgHack.png
      public/stylesheets/re_view_button/oval-blue-left.gif
      public/stylesheets/re_view_button/oval-green-right.gif
      public/stylesheets/re_view_box/whitebox.jpg
      app/views/re_pipeline_jobs/index.js.erb
      app/views/re_jobs/_empty.html.erb
      public/images/re_rule/move-up-48.png
      public/images/re_rule/edit-18.png
      public/images/re_job/error-25.png
      app/views/re_rules/update.js.erb
      public/images/re_job/next-disabled-14.png
      app/views/re_jobs/show.html.erb
      public/images/re_pipeline/change-48.png
      public/images/re_pipeline/destroy-48.png
      public/images/re_pipeline/activate-48.png
      public/images/re_rule/stop-success-48.png
      public/images/re_pipeline/list-18.png
      app/views/re_pipeline_jobs/_index.html.erb
      public/images/re_rule/next-change-25.png
      public/images/re_rule/move-up-14.png
      public/images/re_pipeline/change-14.png
      public/images/re_pipeline/activate-14.png
      public/images/re_rule/stop-success-14.png
      app/views/re_pipelines/index.html.erb
      app/views/re_pipelines/_edit.html.erb
      public/images/re_rule/next-change-18.png
      public/images/re_rule/next-show-48.png
      public/images/re_pipeline/current-14.png
      public/images/loadingAnimation.gif
      public/images/re_pipeline/edit-25.png
      app/views/re_rules/_index.html.erb
      public/stylesheets/blueprint/src/ie.css
      public/images/re_rule/verify-25.png
      public/images/re_rule/__destroy-25.png
      spec/models/re_rule_outcome_spec.rb
      app/views/re_pipelines/_show_actions.html.erb
      app/views/re_pipeline_jobs/index.html.erb
      app/views/re_pipelines/_change.html.erb
      public/images/re_rule_class/list-down.png
      public/images/re_pipeline/alert-18.png
      public/images/re_rule/verify-18.png
      public/images/re_rule/__destroy-18.png
      public/images/re_pipeline/__destroy-14.png
      public/images/re_pipeline/verify-25.png
      public/images/re_pipeline/edit-18.png
      public/javascripts/re_pipeline_index.js
      public/images/re_rule/next-show-14.png
      app/views/re_rules/new.js.erb
      public/images/re_job/success-14.png
      app/views/re_rules/_new.html.erb
      public/images/re_job/prev-enabled-48.png
      app/views/re_rules/_help.html.erb
      public/images/re_pipeline/__destroy-48.png
      public/images/re_job/prev-disabled-18.png
      app/models/re_job.rb
      public/images/re_pipeline/deactivate-48.png
      public/images/re_rule_class/add-48.png
      app/views/re_rules/_error.html.erb
      public/stylesheets/blueprint/src/grid.css
      public/images/re_rule/stop-failure-18.png
      public/images/re_pipeline/changed-25.png
      public/images/re_pipeline/draft-48.png
      public/images/re_rule/destroy-18.png
      public/images/re_rule/valid-48.png
      app/views/re_pipelines/new.html.erb
      public/stylesheets/re_pipeline.css
      app/controllers/re_rules_controller.rb
      public/images/re_pipeline/new-25.png
      public/images/re_job/prev-enabled-14.png
      public/images/re_rule/move-up-off-48.png
      public/stylesheets/re_view_button/oval-green-left.gif
      public/stylesheets/blueprint/print.css
      public/images/re_job/info-25.png
      public/stylesheets/blueprint/src/grid.png
      public/javascripts/re_pipeline_new.js
      public/stylesheets/re_view_navigate.css
      public/stylesheets/re_view_box/accept.png
      public/images/re_rule/move-up-off-14.png
      public/images/re_rule_class/new-14.png
      public/stylesheets/blueprint/src/reset.css
      app/views/re_rules/destroy.js.erb
      app/views/layouts/rules_engine.html.erb
      public/images/re_job/list-25.png
      public/images/re_job/loadingAnimation.gif
      public/images/re_job/error-48.png
      public/stylesheets/re_pipeline/accept.png
      public/images/re_job/next-disabled-25.png
      app/views/re_pipelines/template.html.erb
      public/stylesheets/re_view_navigate/subnavitems-bg.jpg
      public/stylesheets/blueprint/plugins/fancy-type/readme.txt
      public/images/re_pipeline/verify-14.png
      public/images/re_rule/next-change-48.png
      public/images/re_job/error-14.png
      app/views/re_pipelines/_change_actions.html.erb
      public/images/re_rule/move-down-off-14.png
      public/images/re_rule/move-up-25.png
      public/javascripts/re_pipeline_jobs.js
      public/stylesheets/blueprint/plugins/rtl/screen.css
      public/images/re_pipeline/alert-48.png
      public/images/re_rule/verify-48.png
      public/images/re_rule/__destroy-48.png
      public/images/re_pipeline/show-18.png
      public/images/re_pipeline/edit-48.png
      public/images/re_rule_class/list-right.png
      public/images/re_pipeline/verify-48.png
      public/stylesheets/blueprint/src/print.css
      public/images/re_pipeline/current-18.png
      public/images/re_rule/edit-25.png
      public/stylesheets/blueprint/plugins/buttons/icons/key.png
      app/views/re_pipelines/_show.html.erb
      app/models/re_pipeline_activated_observer.rb
      public/images/re_rule/next-show-25.png
      public/images/re_pipeline/list-25.png
      app/controllers/re_pipelines_controller.rb
      public/stylesheets/blueprint/plugins/link-icons/screen.css
      spec/support/blueprint_re_pipelines.rb
      public/stylesheets/re_view.css
      public/stylesheets/re_view_button.css
      app/models/re_pipeline_base.rb
      public/stylesheets/re_view_navigate/subnavitems-bg.gif
      public/images/re_job/success-18.png
      app/models/re_job_audit.rb
      public/stylesheets/re_view_button/icon-add.png
      public/stylesheets/blueprint/plugins/buttons/icons/tick.png
      public/stylesheets/blueprint/plugins/link-icons/icons/external.png
      public/images/re_rule/destroy-25.png
      public/images/re_pipeline/changed-48.png
      app/views/re_jobs/_index.html.erb
      public/images/re_rule/stop-failure-25.png
      public/stylesheets/re_view_form.css
      public/images/re_pipeline/list-right.png
      app/views/re_rules/error.js.erb
      public/images/re_pipeline/revert-18.png
      public/images/re_job/info-48.png
      public/javascripts/jquery.blockUI.js
      db/migrate/20100308225008_create_re_pipelines.rb
      public/stylesheets/re_view_button/oval-orange-left.gif
      public/stylesheets/re_view_button/oval-orange-right.gif
      public/stylesheets/blueprint/ie.css
      public/images/re_rule/move-down-18.png
      public/images/re_job/next-enabled-14.png
      public/images/re_pipeline/changed-14.png
      public/images/re_pipeline/deactivate-14.png
      public/images/re_rule_class/add-14.png
      public/images/re_rule_class/help-14.png
      spec/models/re_job_spec.rb
      public/stylesheets/re_view_button/oval-gray-left.gif
      public/stylesheets/re_view_button/oval-gray-right.gif
      public/stylesheets/re_view_box/exclamation.png
      public/images/re_pipeline/draft-14.png
      app/views/re_rules/_empty.js.erb
      public/images/re_rule/valid-14.png
      public/images/re_rule_class/help-18.png
      public/images/re_job/prev-disabled-25.png
      spec/models/re_job_audit_spec.rb
      public/stylesheets/re_view_button/oval-red-left.gif
      public/images/re_job/list-48.png
      public/images/re_job/info-14.png
      public/images/re_pipeline/new-18.png
      public/images/re_rule/goto-pipeline-14.png
      public/stylesheets/re_view_button/oval-red-right.gif
      public/stylesheets/blueprint/plugins/link-icons/icons/im.png
      public/images/re_pipeline/list-down.png
      app/views/re_rules/_change.html.erb
      public/stylesheets/blueprint/plugins/fancy-type/screen.css
      app/views/re_pipelines/update.js.erb
      app/views/re_pipelines/create.js.erb
      public/javascripts/re_jobs.js
      lib/tasks/re_runner.rake
      public/stylesheets/re_view_button/checked-on.gif
      public/images/re_pipeline/show-25.png
      app/views/re_rules/edit.js.erb
      app/controllers/re_jobs_controller.rb
      public/stylesheets/re_view_button/icon-delete.png
      public/stylesheets/blueprint/plugins/buttons/icons/cross.png
      public/stylesheets/blueprint/plugins/buttons/screen.css
      public/images/re_job/next-disabled-18.png
      app/views/re_pipelines/_confirm.html.erb
      public/images/re_rule/move-down-off-25.png
      public/images/re_pipeline/list-14.png
      public/javascripts/jquery-1.3.2.min.js
      app/controllers/re_pipeline_jobs_controller.rb
      public/stylesheets/blueprint/plugins/link-icons/icons/visited.png
      app/views/re_pipelines/change.html.erb
      public/images/re_rule/edit-48.png
      public/javascripts/re_view.js
      app/views/re_pipelines/edit.js.erb
      public/images/re_rule/move-up-18.png
      public/images/re_pipeline/destroy-14.png
      public/images/re_rule/next-change-14.png
      public/stylesheets/blueprint/plugins/link-icons/icons/pdf.png
      public/stylesheets/blueprint/plugins/link-icons/icons/xls.png
      public/images/re_pipeline/list-48.png
      public/images/re_pipeline/change-18.png
      public/images/re_pipeline/activate-18.png
      app/views/re_rules/help.html.erb
      public/images/re_rule/stop-success-18.png
      app/models/re_rule.rb
      app/models/re_pipeline_activated.rb
      public/images/re_rule/verify-14.png
      public/images/re_pipeline/edit-14.png
      public/images/re_pipeline/alert-14.png
      public/stylesheets/blueprint/plugins/link-icons/icons/email.png
      public/images/re_pipeline/__destroy-18.png
      app/helpers/re_pipeline_helper.rb
      app/views/re_pipelines/_new.html.erb
      public/images/re_rule/stop-failure-48.png
      public/images/re_rule/next-show-18.png
      public/stylesheets/blueprint/src/typography.css
      public/images/re_rule/destroy-48.png
      public/stylesheets/re_view_button/checked-off.gif
      public/stylesheets/blueprint/plugins/link-icons/readme.txt
      public/images/re_pipeline/current-25.png
      public/images/re_pipeline/revert-25.png
      public/images/re_job/prev-disabled-14.png
      spec/models/re_pipeline_base_spec.rb
      app/views/re_rules/help.js.erb
      app/views/re_pipelines/new.js.erb
      app/views/re_pipeline_jobs/_empty.html.erb
      spec/models/re_rule_spec.rb
      app/views/re_rules/new.html.erb
      public/images/re_rule/destroy-14.png
      public/images/re_rule/move-down-25.png
      public/stylesheets/blueprint/screen.css
      public/images/re_rule/stop-failure-14.png
      public/javascripts/thickbox.js
      public/stylesheets/blueprint/plugins/link-icons/icons/doc.png
      public/stylesheets/blueprint/plugins/link-icons/icons/feed.png
      public/images/re_rule_class/help-25.png
      public/images/re_job/list-14.png
      public/images/re_job/next-enabled-25.png
      public/images/re_job/prev-disabled-48.png
      public/images/re_job/next-enabled-18.png
      public/images/re_rule/valid-25.png
      public/images/re_job/success-25.png
      public/images/re_job/prev-enabled-18.png
      public/stylesheets/re_view_box.css
      public/stylesheets/jquery.autocomplete.css
      public/javascripts/jquery.autocomplete.pack.js
      app/views/re_jobs/index.html.erb
      app/views/re_jobs/show.js.erb
      public/images/re_rule_class/new-25.png
      public/stylesheets/re_view_navigate/subnav-bg.jpg
      public/stylesheets/re_view_box/shadowbox.png
      public/images/re_rule/move-up-off-18.png
      public/images/re_rule_class/new-18.png
      public/images/re_pipeline/show-48.png
      public/images/re_job/goto-16.png
      public/stylesheets/re_view_button/oval-blue-right.gif
      public/images/re_rule/edit-14.png
      public/images/re_rule/move-down-off-48.png
      public/images/re_pipeline/show-14.png
      public/images/re_pipeline/verify-18.png
      public/stylesheets/blueprint/plugins/buttons/readme.txt
      public/images/re_pipeline/destroy-25.png
      public/images/re_pipeline/change-25.png
      public/images/re_pipeline/activate-25.png
      public/images/re_rule/stop-success-25.png
      app/views/re_rules/_edit.html.erb
      public/images/re_rule/move-down-off-18.png
      public/images/re_job/error-18.png
      doc/README.rules_engine
      public/stylesheets/blueprint/plugins/rtl/readme.txt
      app/views/re_rules/_show.html.erb
      public/images/re_pipeline/destroy-18.png
      spec/models/re_pipeline_activated_spec.rb
      public/javascripts/re_pipeline_change.js
      doc/README.rules_engine_view
      public/images/re_pipeline/alert-25.png
      app/views/re_jobs/index.js.erb
      app/views/re_pipelines/_index.html.erb
      spec/controllers/re_pipelines_controller_spec.rb
      public/stylesheets/re_view_navigate/add-new-icon.png
      public/images/re_rule/__destroy-14.png
      public/stylesheets/re_view_navigate/icon-add.png
      public/stylesheets/re_pipeline/exclamation.png
      app/views/re_rules/error.html.erb
      public/images/re_pipeline/revert-48.png
      public/images/re_pipeline/current-48.png
    ).each do |filename|
      m.file filename, filename
    end

  end
end
