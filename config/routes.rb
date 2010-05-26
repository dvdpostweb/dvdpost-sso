DvdpostSso::Application.routes.draw do |map|
  devise_for :customers
  get 'login',  :to => redirect('/customers/sign_in')
  get 'logout', :to => redirect('/customers/sign_out')

  get  'authorization/new'   => 'authorization#new'
  post 'authorization/token' => 'authorization#token'

  get 'me', :to => 'authorization#me' # For test purposes
  root :to => 'authorization#me'
end
