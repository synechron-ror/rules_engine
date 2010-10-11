class CreateRulesEngine < ActiveRecord::Migration
  def self.up

    create_table :re_plans do |t|
      t.string  :code
      t.string  :title
      t.text    :description
      
      t.integer :plan_status
      t.integer :plan_version
      
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :re_plan_workflows do |t|
      t.integer :re_plan_id
      t.integer :re_workflow_id  
      t.integer :position          
    end
      
    create_table :re_workflows do |t|
      t.string  :code
      t.string  :title
      t.text    :description
      
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    #################################
    create_table :re_rules do |t|
      t.integer :re_workflow_id
      
      t.integer :position

      t.string  :rule_class_name

      t.string  :title
      t.string  :summary      
      t.text    :data
      
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :re_rules, [:re_workflow_id]
    add_index :re_rules, [:re_workflow_id, :position]

    
    #################################
    create_table :re_published_plans do |t|
      t.string   :plan_code
      t.integer  :plan_version
      t.string   :version_tag
            
      t.datetime :published_at
      t.text     :data
    end    

    add_index :re_published_plans, [:plan_code]
    add_index :re_published_plans, [:plan_code, :plan_version]
    
    create_table :re_process_runs do |t|
      t.string   :plan_code
      t.integer  :plan_version
      t.integer  :process_status
      t.datetime :created_at
      t.datetime :started_at
      t.datetime :finished_at
    end    

    add_index :re_process_runs, [:plan_code]
    add_index :re_process_runs, [:process_status]
    add_index :re_process_runs, [:started_at]
    add_index :re_process_runs, [:finished_at]

    create_table :re_process_audits do |t|
      t.integer  :process_id
            
      t.datetime :created_at
      t.integer  :code
      t.string   :message            
    end    

    add_index :re_process_audits, [:process_id]
    
  end

  def self.down
    drop_table :re_published_plans
    drop_table :re_process_runs
    drop_table :re_process_audits
    
    drop_table :re_rules
    drop_table :re_workflows
    drop_table :re_plan_workflows
    drop_table :re_plans
  end
end
