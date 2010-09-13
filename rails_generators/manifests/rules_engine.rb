class RulesEngineManifest
  def self.populate_record(m)

    %W(
      app/controllers
      app/helpers
      app/models
      app/views/layouts
      app/views/re_history
      app/views/re_plan_workflow_rules
      app/views/re_plan_workflows
      app/views/re_plans
      app/views/re_publications
      app/views/re_workflow_rules
      app/views/re_workflows
      config/initializers
      db/migrate
      doc
      features/re_pipeline
      features/step_definitions/common
      features/support
      lib/tasks
      public/javascripts
      public/javascripts/rules_engine
      public/stylesheets
      public/stylesheets/blueprint
      public/stylesheets/blueprint/plugins
      public/stylesheets/blueprint/plugins/buttons
      public/stylesheets/blueprint/plugins/buttons/icons
      public/stylesheets/blueprint/plugins/fancy-type
      public/stylesheets/blueprint/plugins/link-icons
      public/stylesheets/blueprint/plugins/link-icons/icons
      public/stylesheets/blueprint/plugins/rtl
      public/stylesheets/blueprint/src
      public/stylesheets/fancybox
      public/stylesheets/rules_engine
      public/stylesheets/rules_engine/images
      public/stylesheets/rules_engine/images/re_view_box
      public/stylesheets/rules_engine/images/re_view_button
      public/stylesheets/rules_engine/images/re_view_error
      public/stylesheets/rules_engine/images/re_view_navigate
      public/stylesheets/rules_engine/images/rules_engine
      public/stylesheets/rules_engine/images/rules_engine/re_common
      public/stylesheets/rules_engine/images/rules_engine/re_history
      public/stylesheets/rules_engine/images/rules_engine/re_plan
      public/stylesheets/rules_engine/images/rules_engine/re_publication
      public/stylesheets/rules_engine/images/rules_engine/re_rule
      public/stylesheets/rules_engine/images/rules_engine/re_workflow
      spec/controllers
      spec/helpers
      spec/models
      spec/support
    ).each do |dirname|
      m.directory dirname
    end

    %W(
      app/controllers/re_history_controller.rb
      app/controllers/re_plan_workflow_rules_controller.rb
      app/controllers/re_plan_workflows_controller.rb
      app/controllers/re_plans_controller.rb
      app/controllers/re_publications_controller.rb
      app/controllers/re_workflow_rules_controller.rb
      app/controllers/re_workflows_controller.rb
      app/helpers/rules_engine_helper.rb
      app/models/re_plan.rb
      app/models/re_plan_workflow.rb
      app/models/re_rule.rb
      app/models/re_workflow.rb
      app/views/layouts/rules_engine.html.erb
      app/views/re_history/_index_prepare.html.erb
      app/views/re_history/_index_update.html.erb
      app/views/re_history/_show.html.erb
      app/views/re_history/index.html.erb
      app/views/re_history/index.js.erb
      app/views/re_history/show.html.erb
      app/views/re_history/show.js.erb
      app/views/re_plan_workflow_rules/edit.html.erb
      app/views/re_plan_workflow_rules/edit.js.erb
      app/views/re_plan_workflow_rules/error.html.erb
      app/views/re_plan_workflow_rules/error.js.erb
      app/views/re_plan_workflow_rules/help.html.erb
      app/views/re_plan_workflow_rules/help.js.erb
      app/views/re_plan_workflow_rules/new.html.erb
      app/views/re_plan_workflow_rules/new.js.erb
      app/views/re_plan_workflow_rules/update.js.erb
      app/views/re_plan_workflows/change.html.erb
      app/views/re_plan_workflows/copy.html.erb
      app/views/re_plan_workflows/copy.js.erb
      app/views/re_plan_workflows/edit.html.erb
      app/views/re_plan_workflows/edit.js.erb
      app/views/re_plan_workflows/new.html.erb
      app/views/re_plan_workflows/new.js.erb
      app/views/re_plan_workflows/show.html.erb
      app/views/re_plan_workflows/update.js.erb
      app/views/re_plans/_change.html.erb
      app/views/re_plans/_copy.html.erb
      app/views/re_plans/_edit.html.erb
      app/views/re_plans/_empty.html.erb
      app/views/re_plans/_index.html.erb
      app/views/re_plans/_menu.html.erb
      app/views/re_plans/_new.html.erb
      app/views/re_plans/_preview.html.erb
      app/views/re_plans/_show.html.erb
      app/views/re_plans/_workflow_change.html.erb
      app/views/re_plans/_workflow_preview.html.erb
      app/views/re_plans/_workflow_show.html.erb
      app/views/re_plans/change.html.erb
      app/views/re_plans/copy.html.erb
      app/views/re_plans/copy.js.erb
      app/views/re_plans/create.js.erb
      app/views/re_plans/edit.html.erb
      app/views/re_plans/edit.js.erb
      app/views/re_plans/history.html.erb
      app/views/re_plans/history.js.erb
      app/views/re_plans/index.html.erb
      app/views/re_plans/index.js.erb
      app/views/re_plans/new.html.erb
      app/views/re_plans/new.js.erb
      app/views/re_plans/preview.html.erb
      app/views/re_plans/preview.js.erb
      app/views/re_plans/show.html.erb
      app/views/re_plans/template.html.erb
      app/views/re_plans/update.js.erb
      app/views/re_publications/_show_prepare.html.erb
      app/views/re_publications/_show_update.html.erb
      app/views/re_publications/show.html.erb
      app/views/re_publications/show.js.erb
      app/views/re_workflow_rules/_edit.html.erb
      app/views/re_workflow_rules/_error.html.erb
      app/views/re_workflow_rules/_help.html.erb
      app/views/re_workflow_rules/_new.html.erb
      app/views/re_workflow_rules/edit.html.erb
      app/views/re_workflow_rules/edit.js.erb
      app/views/re_workflow_rules/error.html.erb
      app/views/re_workflow_rules/error.js.erb
      app/views/re_workflow_rules/help.html.erb
      app/views/re_workflow_rules/help.js.erb
      app/views/re_workflow_rules/new.html.erb
      app/views/re_workflow_rules/new.js.erb
      app/views/re_workflow_rules/update.js.erb
      app/views/re_workflows/_add_prepare.html.erb
      app/views/re_workflows/_add_update.html.erb
      app/views/re_workflows/_copy.html.erb
      app/views/re_workflows/_edit.html.erb
      app/views/re_workflows/_empty.html.erb
      app/views/re_workflows/_index.html.erb
      app/views/re_workflows/_menu.html.erb
      app/views/re_workflows/_new.html.erb
      app/views/re_workflows/_plan_prepare.html.erb
      app/views/re_workflows/_plan_update.html.erb
      app/views/re_workflows/_preview.html.erb
      app/views/re_workflows/_rule_change.html.erb
      app/views/re_workflows/_rule_empty.html.erb
      app/views/re_workflows/_rule_preview.html.erb
      app/views/re_workflows/_rule_show.html.erb
      app/views/re_workflows/_show.html.erb
      app/views/re_workflows/add.html.erb
      app/views/re_workflows/add.js.erb
      app/views/re_workflows/change.html.erb
      app/views/re_workflows/copy.html.erb
      app/views/re_workflows/copy.js.erb
      app/views/re_workflows/create.js.erb
      app/views/re_workflows/edit.html.erb
      app/views/re_workflows/edit.js.erb
      app/views/re_workflows/index.html.erb
      app/views/re_workflows/new.html.erb
      app/views/re_workflows/new.js.erb
      app/views/re_workflows/plan.html.erb
      app/views/re_workflows/plan.js.erb
      app/views/re_workflows/preview.html.erb
      app/views/re_workflows/preview.js.erb
      app/views/re_workflows/show.html.erb
      app/views/re_workflows/update.js.erb
      config/initializers/rules_engine.rb
      db/migrate/20100308225008_create_rules_engine.rb
      doc/README.rules_engine
      doc/README.rules_engine_features
      doc/README.rules_engine_view
      features/re_pipeline/lookup.feature
      features/step_definitions/common/re_debug_steps.rb
      features/step_definitions/common/re_error_steps.rb
      features/step_definitions/common/re_form_steps.rb
      features/step_definitions/common/re_model_steps.rb
      features/step_definitions/common/re_user_steps.rb
      features/step_definitions/common/re_view_steps.rb
      features/support/rules_engine.rb
      lib/tasks/rules_engine.rake
      public/javascripts/jquery-1.4.2.min.js
      public/javascripts/jquery.autocomplete.pack.js
      public/javascripts/jquery.blockUI.js
      public/javascripts/jquery.fancybox-1.3.1.js
      public/javascripts/rules_engine/re_history_index.js
      public/javascripts/rules_engine/re_history_show.js
      public/javascripts/rules_engine/re_plan_change.js
      public/javascripts/rules_engine/re_plan_new.js
      public/javascripts/rules_engine/re_plan_preview.js
      public/javascripts/rules_engine/re_publication_show.js
      public/javascripts/rules_engine/re_view.js
      public/javascripts/rules_engine/re_workflow_add.js
      public/javascripts/rules_engine/re_workflow_change.js
      public/javascripts/rules_engine/re_workflow_new.js
      public/javascripts/rules_engine/re_workflow_plan.js
      public/javascripts/rules_engine/re_workflow_preview.js
      public/javascripts/rules_engine/re_workflow_show.js
      public/stylesheets/blueprint/ie.css
      public/stylesheets/blueprint/plugins/buttons/icons/cross.png
      public/stylesheets/blueprint/plugins/buttons/icons/key.png
      public/stylesheets/blueprint/plugins/buttons/icons/tick.png
      public/stylesheets/blueprint/plugins/buttons/readme.txt
      public/stylesheets/blueprint/plugins/buttons/screen.css
      public/stylesheets/blueprint/plugins/fancy-type/readme.txt
      public/stylesheets/blueprint/plugins/fancy-type/screen.css
      public/stylesheets/blueprint/plugins/link-icons/icons/doc.png
      public/stylesheets/blueprint/plugins/link-icons/icons/email.png
      public/stylesheets/blueprint/plugins/link-icons/icons/external.png
      public/stylesheets/blueprint/plugins/link-icons/icons/feed.png
      public/stylesheets/blueprint/plugins/link-icons/icons/im.png
      public/stylesheets/blueprint/plugins/link-icons/icons/pdf.png
      public/stylesheets/blueprint/plugins/link-icons/icons/visited.png
      public/stylesheets/blueprint/plugins/link-icons/icons/xls.png
      public/stylesheets/blueprint/plugins/link-icons/readme.txt
      public/stylesheets/blueprint/plugins/link-icons/screen.css
      public/stylesheets/blueprint/plugins/rtl/readme.txt
      public/stylesheets/blueprint/plugins/rtl/screen.css
      public/stylesheets/blueprint/print.css
      public/stylesheets/blueprint/screen.css
      public/stylesheets/blueprint/src/forms.css
      public/stylesheets/blueprint/src/grid.css
      public/stylesheets/blueprint/src/grid.png
      public/stylesheets/blueprint/src/ie.css
      public/stylesheets/blueprint/src/print.css
      public/stylesheets/blueprint/src/reset.css
      public/stylesheets/blueprint/src/typography.css
      public/stylesheets/fancybox/blank.gif
      public/stylesheets/fancybox/fancy_close.png
      public/stylesheets/fancybox/fancy_loading.png
      public/stylesheets/fancybox/fancy_nav_left.png
      public/stylesheets/fancybox/fancy_nav_right.png
      public/stylesheets/fancybox/fancy_shadow_e.png
      public/stylesheets/fancybox/fancy_shadow_n.png
      public/stylesheets/fancybox/fancy_shadow_ne.png
      public/stylesheets/fancybox/fancy_shadow_nw.png
      public/stylesheets/fancybox/fancy_shadow_s.png
      public/stylesheets/fancybox/fancy_shadow_se.png
      public/stylesheets/fancybox/fancy_shadow_sw.png
      public/stylesheets/fancybox/fancy_shadow_w.png
      public/stylesheets/fancybox/fancy_title_left.png
      public/stylesheets/fancybox/fancy_title_main.png
      public/stylesheets/fancybox/fancy_title_over.png
      public/stylesheets/fancybox/fancy_title_right.png
      public/stylesheets/fancybox/fancybox-x.png
      public/stylesheets/fancybox/fancybox-y.png
      public/stylesheets/fancybox/fancybox.png
      public/stylesheets/fancybox/jquery.fancybox-1.3.1.css
      public/stylesheets/jquery.autocomplete.css
      public/stylesheets/rules_engine/images/re_view_box/shadowbox.png
      public/stylesheets/rules_engine/images/re_view_box/whitebox.jpg
      public/stylesheets/rules_engine/images/re_view_button/checked-off.gif
      public/stylesheets/rules_engine/images/re_view_button/checked-on.gif
      public/stylesheets/rules_engine/images/re_view_button/icon-add.png
      public/stylesheets/rules_engine/images/re_view_button/icon-delete.png
      public/stylesheets/rules_engine/images/re_view_button/list-add.png
      public/stylesheets/rules_engine/images/re_view_button/list-remove.png
      public/stylesheets/rules_engine/images/re_view_button/list-select.png
      public/stylesheets/rules_engine/images/re_view_button/oval-blue-left.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-blue-right.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-gray-left.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-gray-right.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-green-left.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-green-right.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-orange-left.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-orange-right.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-red-left.gif
      public/stylesheets/rules_engine/images/re_view_button/oval-red-right.gif
      public/stylesheets/rules_engine/images/re_view_error/re-alert-close.png
      public/stylesheets/rules_engine/images/re_view_navigate/breadcrumb.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/list-next-disabled-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/list-next-enabled-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/list-prev-disabled-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/list-prev-enabled-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/loading.gif
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-changed-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-changed-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-draft-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-draft-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-error-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-info-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-published-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-published-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-success-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-valid-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-valid-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-verify-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-verify-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_common/status-verify-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_history/error-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_history/info-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_history/list-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_history/success-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/alert-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/change-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/copy-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/delete-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/edit-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/list-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/new-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/preview-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/publish-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/revert-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/show-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/title-plural.png
      public/stylesheets/rules_engine/images/rules_engine/re_plan/title-single.png
      public/stylesheets/rules_engine/images/rules_engine/re_publication/show-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/add-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/alert-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/destroy-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/edit-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/error-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/help-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/help-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/icon-ad-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/move-down-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/move-down-off-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/move-up-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/move-up-off-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/new-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/next-down-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/next-right-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/show-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/start-pipeline-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/stop-failure-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/stop-success-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/title-plural.png
      public/stylesheets/rules_engine/images/rules_engine/re_rule/title-single.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/add-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/add-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/add-off-14.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/alert-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/change-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/change-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/copy-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/delete-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/edit-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/is-default-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/list-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/make-default-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/make-default-off-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/new-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/plan-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/preview-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/remove-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/show-18.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/show-25.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/title-plural.png
      public/stylesheets/rules_engine/images/rules_engine/re_workflow/title-single.png
      public/stylesheets/rules_engine/screen.css
      spec/controllers/re_application_controller_spec.rb
      spec/controllers/re_history_controller_spec.rb
      spec/controllers/re_plan_workflows_controller_spec.rb
      spec/controllers/re_plans_controller_spec.rb
      spec/controllers/re_publications_controller_spec.rb
      spec/controllers/re_workflows_controller_spec.rb
      spec/helpers/rules_engine_helper_spec.rb
      spec/models/re_plan_spec.rb
      spec/models/re_plan_workflow_spec.rb
      spec/models/re_rule_spec.rb
      spec/models/re_workflow_spec.rb
      spec/support/rules_engine_blueprints.rb
      spec/support/rules_engine_macros.rb
    ).each do |filename|
      m.file filename, filename
    end


  end

  def self.after_generate()
  end

end
