module RulesEngineView
  module ModelLoader
  # options
  # => :parents array of required parent objects
  # => :validate method on the model to validate against the parent
  # => :param_id (default = id)
  # => :find_by (default = find)
  # => :redirect_path
  def re_load_model(model_name, options = {})
    model = re_find_model(model_name, options)
    
    parent = options[:parents] == nil ? nil : options[:parents].last
    if (model != nil && parent != nil)
      if options[:validate]
        model = nil if (instance_variable_get("@#{parent}") == nil || !model.send(options[:validate], instance_variable_get("@#{parent}")))
      else  
        model = nil if (instance_variable_get("@#{parent}") == nil || (instance_variable_get("@#{parent}").id != model.send("#{parent}_id")))
      end  
    end

    instance_variable_set("@#{model_name}", model) 
            
    if model == nil
      flash[:error] = "Unable to load #{model_name.to_s.camelcase}."
      redirect_path = model_index_path(model_name, options)
      respond_to do |format|  
        format.html { redirect_to(redirect_path) }
        format.js   { render :text => "window.location.href = '#{redirect_path}';" }  
      end  
    end
  end  

    ########################################################################  
  private  
    def re_find_model model_name, options
      options.reverse_merge!({:find_by => :find, :param_id =>:id})

      # puts "model : #{model_name}"
      klass = Kernel.const_get("#{model_name}".camelcase)        
      model = klass ? klass.send(options[:find_by], params[options[:param_id]]) : nil
      
      return model
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
      return nil
    end

    def model_index_path(model_name, options = {})
      if options.include? :redirect_path
        
        args = nil
        if options[:parents]
          options[:parents].each do |parent|
            args = [] unless args
            args <<  instance_variable_get("@#{parent}")
          end
        end
      
        args ? send(options[:redirect_path], args) : send(options[:redirect_path]) 
      else
        send("#{model_name.to_s.pluralize}_path")
      end
    end
  end  
end