DvdpostSso::Application.routes.draw do |map|
  devise_for :users

  devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  get 'login', :to => redirect('/users/login')
  get 'logout', :to => redirect('/users/logout')

  resources :users

  match 'authorize' => 'authentication#authorize'

  match 'authentication/hello' => 'authentication#hello'

  root :to => "authentication#hello"
end
