# This is a sample Sinatra app used to test the code
require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'json'

enable :sessions

def client
  @client ||= OAuth2::Client.new( 'dvdpost_client',
                                  'dvdpost_client_secret',
                                  :site => 'http://sso.dvdpost.dev',
                                  :authorize_path => 'authorization/new',
                                  :access_token_path => 'authorization/token')
end

get '/start' do
  redirect client.web_server.authorize_url(:redirect_uri => redirect_uri)
end

get '/callback' do
  access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
  # At this point we should store the access_token.token to the database
  session[:oauth_token] = access_token.token
  session[:expires_in] = access_token.expires_in
  session[:refresh_token] = access_token.refresh_token
  puts "*** Session: #{session.inspect} ***"
  redirect "me?token=#{access_token.token}" # Internal redirect to directly make a test call to the SSO
end

get '/me' do
  access_token = OAuth2::AccessToken.new(client, params[:token])
  content = access_token.get('/me') # This sends access_token in the params, but that should be oauth_token
  puts "*** customer_id = #{JSON.parse(content)['id']} ***"
  "customer_id = #{JSON.parse(content)['id']}"
end

get '/sign_out' do
  access_token = OAuth2::AccessToken.new(client, params[:token])
  access_token.post('/sign_out')
end

get '/refresh' do
  access_token = client.web_server.refresh_access_token(session[:refresh_token])
  session[:oauth_token] = access_token.token
  session[:expires_in] = access_token.expires_in
  session[:refresh_token] = access_token.refresh_token
  puts "*** Session: #{session.inspect} ***"
end

get '/basic' do
  params = {:grant_type => 'user_basic', :client_id => 'dvdpost_client', :client_secret => 'dvdpost_client_secret', :username => 'jj@redstorm.be', :password => 'secret'}
  response = Faraday.post 'http://sso.dvdpost.dev/authorization/token', params
  access_token = JSON.parse(response.body)
  puts "*** access token response (json): #{access_token} ***"
  redirect "me?token=#{access_token['access_token']}" # Internal redirect to directly make a test call to the SSO
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/callback'
  uri.query = nil
  uri.to_s
end
