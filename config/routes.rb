DvdpostSso::Application.routes.draw do |map|
  devise_for :customers
  get 'login',  :to => redirect('/customers/sign_in')
  get 'logout', :to => redirect('/customers/sign_out')

  get  'authorization/new'   => 'authorization#new'
  post 'authorization/token' => 'authorization#token'

  # Old routes
  get 'authorize'      => 'authorization#authorize' # This route should not be used, should use POST /token instead
  get 'validate_token' => 'authorization#validate_token' # This is a route to validate the token. 
                                                         # This actually would be a request to a private resource but 
                                                         # since this is an SSO there are none.
                                                         # We should drop this and use a refresh_token request instead,
                                                         # which means that we should store an expiry_date too at the
                                                         # client's side

  # These are only used during early tests. Should be removed once the system is set up.
  match 'authorization/hello' => 'authorization#hello'
  root :to => 'authorization#hello'
end
