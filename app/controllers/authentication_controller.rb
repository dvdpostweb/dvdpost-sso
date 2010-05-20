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
      head :unauthorized
    end
  end

  def login
    
  end

  def hello
    # validate_token
    @hello = 'SSO is SS with an O.'
  end
end
