DvdpostSso::Application.routes.draw do |map|
  devise_for :customers
  get 'login',  :to => redirect('/customers/sign_in')
  get 'logout', :to => redirect('/customers/sign_out')

  match 'authorize'      => 'authentication#authorize'
  match 'validate_token' => 'authentication#validate_token'

  match 'authentication/hello' => 'authentication#hello'

  root :to => "authentication#hello"
end
