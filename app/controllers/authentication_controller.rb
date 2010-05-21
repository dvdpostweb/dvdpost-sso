require 'oauth2/server'
require 'oauth2/server/request'

class AuthenticationController < ApplicationController
  def validate_token
    req = OAuth2::Server::Request.new do |req|
      req.realm      = "dvdpost.be"
      req.algorithms = 'hmac-sha256'

      req.method = request.method

      req.request_uri = request.fullpath

      req.host_with_port = request.host + request.port.to_s

      req.access_token = params['access_token']

      req.access_token_expired? do
        false
      end

      req.request_header do
        request.authorization
      end
    end
    
    unless req.validate
      #FIXME: NASTY, we need to adapt RSpec (mock worden or smth) 
      warden.custom_failure! if warden
      head :unauthorized
    end
  end

  def authorize
    callback_uri = params[:callback_uri]
    authenticate_user!
    redirect_to callback_url
  end

  def callback_uri(root_uri, token)
    root_uri += root_uri.matches(/\?/) ? "&code=#{token}" : "?code=#{token}"
  end

  def hello
    validate_token
    # authenticate_user!
    @hello = 'SSO is SS with an O.'
  end
end
