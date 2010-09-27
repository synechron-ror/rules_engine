class LayoutManifest
  def self.populate_record(m, rule_name)

    %W(
    ).each do |dirname|
      m.empty_directory dirname
    end

    %W(
    ).each do |filename|
      m.copy_file filename, filename
    end

    m.template "app/views/layouts/rules_engine_layout.html.erb",  "app/views/layouts/#{rule_name}.html.erb"

  end
end
