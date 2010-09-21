Rails::Application.routes.draw do

  resources :re_plans do
    member do
      get 'change'
      get 'preview'
      put 'publish'
      put 'revert'
      get 'history'
      get 'copy'
      post 'duplicate'
    end
  
    resources :workflows, :controller => :re_plan_workflows, :except => [:index] do
      member do
        get 'change'
        put 'default'
        put 'add'
        put 'remove'
        get 'copy'
        post 'duplicate'
      end  
      
      resources :rules, :controller => :re_plan_workflow_rules, :except => [:index, :show] do
        collection do
          get 'help'
          get 'error'
        end
                
        member do
          put 'move_up'
          puts 'move_down'
        end  
      end                                         
    end  
  end

  resources :re_workflows do
    collection do
      get 'add'
    end
    
    member do
      get 'plan'
      get 'change'
      get 'preview'
      get 'copy'
      post 'duplicate'
    end
                      
    resources :rules, :controller => :re_workflow_rules, :except => [:index, :show] do
      collection do
        get 'help'
        get 'error'
      end  
         
      member do
        put 'move_up'
        puts 'move_down'
      end
    end    
  end  

  match '/re_history'       => 're_history#index'
  match '/re_history/:id'   => 're_history#show'
  match '/re_publications'  => 're_publications#show'
end  