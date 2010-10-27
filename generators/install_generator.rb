module RulesEngine
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      def initialize(runtime_args, *runtime_options)
        super
      end

      def install

        %W(
          config/initializers
          db/migrate
          doc
          public/javascripts/rules_engine
          public/stylesheets/rules_engine
          public/stylesheets/rules_engine/images
          public/stylesheets/rules_engine/images/re_common
          public/stylesheets/rules_engine/images/re_history
          public/stylesheets/rules_engine/images/re_plan
          public/stylesheets/rules_engine/images/re_publication
          public/stylesheets/rules_engine/images/re_rule
          public/stylesheets/rules_engine/images/re_view_box
          public/stylesheets/rules_engine/images/re_view_button
          public/stylesheets/rules_engine/images/re_view_error
          public/stylesheets/rules_engine/images/re_view_navigate
          public/stylesheets/rules_engine/images/re_workflow
        ).each do |dirname|
          empty_directory dirname
        end

        %W(
          config/initializers/rules_engine.rb
          db/migrate/20100308225008_create_rules_engine.rb
          doc/README.rules_engine
          public/javascripts/rules_engine/re_history_index.js
          public/javascripts/rules_engine/re_history_show.js
          public/javascripts/rules_engine/re_plan_change.js
          public/javascripts/rules_engine/re_plan_new.js
          public/javascripts/rules_engine/re_plan_preview.js
          public/javascripts/rules_engine/re_publication_show.js
          public/javascripts/rules_engine/re_workflow_add.js
          public/javascripts/rules_engine/re_workflow_change.js
          public/javascripts/rules_engine/re_workflow_new.js
          public/javascripts/rules_engine/re_workflow_plan.js
          public/javascripts/rules_engine/re_workflow_preview.js
          public/javascripts/rules_engine/re_workflow_show.js
          public/stylesheets/rules_engine/images/re_common/list-next-disabled-14.png
          public/stylesheets/rules_engine/images/re_common/list-next-enabled-14.png
          public/stylesheets/rules_engine/images/re_common/list-prev-disabled-14.png
          public/stylesheets/rules_engine/images/re_common/list-prev-enabled-14.png
          public/stylesheets/rules_engine/images/re_common/loading.gif
          public/stylesheets/rules_engine/images/re_common/status-changed-18.png
          public/stylesheets/rules_engine/images/re_common/status-changed-25.png
          public/stylesheets/rules_engine/images/re_common/status-draft-18.png
          public/stylesheets/rules_engine/images/re_common/status-draft-25.png
          public/stylesheets/rules_engine/images/re_common/status-error-14.png
          public/stylesheets/rules_engine/images/re_common/status-info-14.png
          public/stylesheets/rules_engine/images/re_common/status-published-18.png
          public/stylesheets/rules_engine/images/re_common/status-published-25.png
          public/stylesheets/rules_engine/images/re_common/status-success-14.png
          public/stylesheets/rules_engine/images/re_common/status-valid-14.png
          public/stylesheets/rules_engine/images/re_common/status-valid-18.png
          public/stylesheets/rules_engine/images/re_common/status-verify-14.png
          public/stylesheets/rules_engine/images/re_common/status-verify-18.png
          public/stylesheets/rules_engine/images/re_common/status-verify-25.png
          public/stylesheets/rules_engine/images/re_history/error-14.png
          public/stylesheets/rules_engine/images/re_history/info-14.png
          public/stylesheets/rules_engine/images/re_history/list-25.png
          public/stylesheets/rules_engine/images/re_history/success-14.png
          public/stylesheets/rules_engine/images/re_plan/alert-25.png
          public/stylesheets/rules_engine/images/re_plan/change-25.png
          public/stylesheets/rules_engine/images/re_plan/copy-25.png
          public/stylesheets/rules_engine/images/re_plan/delete-25.png
          public/stylesheets/rules_engine/images/re_plan/edit-25.png
          public/stylesheets/rules_engine/images/re_plan/list-25.png
          public/stylesheets/rules_engine/images/re_plan/new-25.png
          public/stylesheets/rules_engine/images/re_plan/preview-18.png
          public/stylesheets/rules_engine/images/re_plan/publish-25.png
          public/stylesheets/rules_engine/images/re_plan/revert-25.png
          public/stylesheets/rules_engine/images/re_plan/show-25.png
          public/stylesheets/rules_engine/images/re_plan/title-plural.png
          public/stylesheets/rules_engine/images/re_plan/title-single.png
          public/stylesheets/rules_engine/images/re_publication/show-25.png
          public/stylesheets/rules_engine/images/re_rule/add-14.png
          public/stylesheets/rules_engine/images/re_rule/alert-25.png
          public/stylesheets/rules_engine/images/re_rule/destroy-25.png
          public/stylesheets/rules_engine/images/re_rule/edit-25.png
          public/stylesheets/rules_engine/images/re_rule/error-25.png
          public/stylesheets/rules_engine/images/re_rule/help-14.png
          public/stylesheets/rules_engine/images/re_rule/help-25.png
          public/stylesheets/rules_engine/images/re_rule/icon-ad-25.png
          public/stylesheets/rules_engine/images/re_rule/move-down-25.png
          public/stylesheets/rules_engine/images/re_rule/move-down-off-25.png
          public/stylesheets/rules_engine/images/re_rule/move-up-25.png
          public/stylesheets/rules_engine/images/re_rule/move-up-off-25.png
          public/stylesheets/rules_engine/images/re_rule/new-25.png
          public/stylesheets/rules_engine/images/re_rule/next-down-25.png
          public/stylesheets/rules_engine/images/re_rule/next-right-18.png
          public/stylesheets/rules_engine/images/re_rule/show-25.png
          public/stylesheets/rules_engine/images/re_rule/start-pipeline-18.png
          public/stylesheets/rules_engine/images/re_rule/stop-failure-18.png
          public/stylesheets/rules_engine/images/re_rule/stop-success-18.png
          public/stylesheets/rules_engine/images/re_rule/title-plural.png
          public/stylesheets/rules_engine/images/re_rule/title-single.png
          public/stylesheets/rules_engine/images/re_workflow/add-14.png
          public/stylesheets/rules_engine/images/re_workflow/add-25.png
          public/stylesheets/rules_engine/images/re_workflow/add-off-14.png
          public/stylesheets/rules_engine/images/re_workflow/alert-25.png
          public/stylesheets/rules_engine/images/re_workflow/change-18.png
          public/stylesheets/rules_engine/images/re_workflow/change-25.png
          public/stylesheets/rules_engine/images/re_workflow/copy-25.png
          public/stylesheets/rules_engine/images/re_workflow/delete-25.png
          public/stylesheets/rules_engine/images/re_workflow/edit-25.png
          public/stylesheets/rules_engine/images/re_workflow/is-default-18.png
          public/stylesheets/rules_engine/images/re_workflow/list-25.png
          public/stylesheets/rules_engine/images/re_workflow/make-default-18.png
          public/stylesheets/rules_engine/images/re_workflow/make-default-off-18.png
          public/stylesheets/rules_engine/images/re_workflow/new-25.png
          public/stylesheets/rules_engine/images/re_workflow/plan-25.png
          public/stylesheets/rules_engine/images/re_workflow/preview-18.png
          public/stylesheets/rules_engine/images/re_workflow/remove-18.png
          public/stylesheets/rules_engine/images/re_workflow/show-18.png
          public/stylesheets/rules_engine/images/re_workflow/show-25.png
          public/stylesheets/rules_engine/images/re_workflow/title-plural.png
          public/stylesheets/rules_engine/images/re_workflow/title-single.png
          public/stylesheets/rules_engine/rules_engine.css
        ).each do |filename|
          copy_file filename, filename
        end

        InstallGenerator.description
      end

      def self.description
        <<-DESCRIPTION
        DESCRIPTION
      end

      desc(description)

      protected
    end
  end
end
