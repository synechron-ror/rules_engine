class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :rules_engine_reader?, :rules_engine_editor?
  
  def rules_engine_reader?
    # why cookies[:rules_engine_reader] ? It's a workaround for cucumber testing
    return cookies[:rules_engine_reader].nil? ? true : 
                                                cookies[:rules_engine_reader].downcase == 'true'
  end  
  
  def rules_engine_editor?
    # why cookies[:rules_engine_editor] ? It's a workaround for cucumber testing
    return cookies[:rules_engine_editor].nil? ? true : 
                                                cookies[:rules_engine_editor].downcase == 'true'
  end  

  def rules_engine_reader_access_required
    unless rules_engine_reader?    
      redirect_to(root_path) 
      flash[:success] = 'Rules Engine Access Denied.'
    end  
  end
  
  def rules_engine_editor_access_required
    unless rules_engine_editor?    
      redirect_to(root_path) 
      flash[:success] = 'Rules Engine Editor Access Denied.'
    end
  end

end
