DvdpostSso::Application.routes.draw do |map|
  devise_for :customers
  get 'login',  :to => redirect('/customers/sign_in')
  get 'logout', :to => redirect('/customers/sign_out')

  get  'authorization/new'   => 'authorization#new'
  post 'authorization/token' => 'authorization#token'

  get 'hello', :to => 'authorization#hello' # For test purposes
  root :to => 'authorization#hello'
end
