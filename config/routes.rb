DvdpostSso::Application.routes.draw do |map|
  devise_for :customers
  get 'login',  :to => redirect('/customers/sign_in')

  controller :authorization do
    namespace :authorization do
      get  'new'   , :to => :new
      post 'token' , :to => :token
    end
    get 'me',     :to => :me
    get 'logout', :to => :logout
  end

  root :to => 'authorization#me'
end
