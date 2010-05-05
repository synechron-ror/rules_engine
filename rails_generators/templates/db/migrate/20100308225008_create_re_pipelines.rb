class CreateRePipelines < ActiveRecord::Migration
  def self.up
    create_table :re_pipelines do |t|
      t.string   :type
      t.integer  :parent_re_pipeline_id      
      
      t.string  :code
      t.string  :title
      t.text    :description
      
      t.datetime :created_at
      t.datetime :updated_at
    end
    
    add_index :re_pipelines, [:id, :type]
    add_index :re_pipelines, [:type]

    #################################
    create_table :re_rules do |t|
      t.integer :re_pipeline_id
      
      t.integer :position

      t.string  :rule_class_name

      t.string  :title
      t.string  :summary      
      t.integer :data_version
      t.text    :data      
      t.string  :error
      
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :re_rules, [:re_pipeline_id]
    add_index :re_rules, [:re_pipeline_id, :position]

    #################################
    create_table :re_rule_outcomes do |t|
      t.integer :re_rule_id
      
      t.integer :outcome
      t.string  :pipeline_code      
      
      t.datetime :created_at
      t.datetime :updated_at
    end    
    add_index :re_rule_outcomes, [:re_rule_id]
    
    #################################
    create_table :re_jobs do |t|
      t.integer  :job_status
      t.datetime :created_at
    end    

    create_table :re_job_audits do |t|
      t.integer  :re_job_id
      t.integer  :re_pipeline_id
      t.integer  :re_rule_id
            
      t.datetime :audit_date
      t.integer  :audit_code
      t.boolean  :audit_success
      t.text     :audit_data            
    end    

    add_index :re_job_audits, [:re_job_id]
    add_index :re_job_audits, [:re_pipeline_id]
    add_index :re_job_audits, [:audit_date]
  end

  def self.down
    drop_table :re_job_audits
    drop_table :re_jobs
    drop_table :re_rule_outcomes
    drop_table :re_rules
    drop_table :re_pipelines
  end
end
