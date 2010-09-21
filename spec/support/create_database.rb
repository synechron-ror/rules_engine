ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :re_published_plans do |t|
    t.string   :plan_code
    t.integer  :plan_version
    t.string   :version_tag
          
    t.datetime :published_at
    t.text     :data
  end
end

ActiveRecord::Schema.define(:version => 1) do
  create_table :re_process_runs do |t|
    t.string   :plan_code
    t.integer  :process_status
    t.datetime :created_at
    t.datetime :started_at
    t.datetime :finished_at
  end
end

ActiveRecord::Schema.define(:version => 1) do
  create_table :re_process_audits do |t|
    t.integer  :process_id
          
    t.datetime :created_at
    t.integer  :code
    t.string   :message            
  end    
end