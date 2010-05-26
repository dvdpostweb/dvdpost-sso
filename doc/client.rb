# This is a sample Sinatra app used to test the code
require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'json'

def client
  @client ||= OAuth2::Client.new( 'dvdpost_client',
                                  'dvdpost_client_secret',
                                  :site => 'https://sso.dvdpost.dev',
                                  :authorize_path => 'authorization/new',
                                  :access_token_path => 'authorization/token')
end

get '/start' do
  redirect client.web_server.authorize_url(:redirect_uri => redirect_uri)
end

get '/callback' do
  access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
  # At this point we should store the access_token.token to the database
  redirect "test?token=#{access_token.token}" # Internal redirect to directly make a test call to the SSO
end

get '/test' do
  # This one still fails at the moment.
  access_token = OAuth2::AccessToken.new(client, params[:token])
  content = access_token.get('/hello')
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/callback'
  uri.query = nil
  uri.to_s
end
