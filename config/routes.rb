DvdpostSso::Application.routes.draw do
  devise_for :customers
  
  controller :authorization do
      get  'authorization/new',   :to => :new, :controller => 'authorization'
      post 'authorization/token', :to => :token, :controller => 'authorization'
    get 'me',          :to => :me
    post 'sign_out',   :to => :sign_customer_out
    get 'remember_me', :to => :remember_me
  end

  root :to => 'authorization#me'
end
