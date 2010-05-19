require 'oauth2/server/request'

class AuthenticationController < ApplicationController
  before_filter :oauth2_verify_request

  def oauth2_verify_request
    oauth_req = OAuth2::Server::Request.new do |req|
      req.realm      = "dvdpost.be"
      req.algorithms = 'hmac-sha256'

      req.method do
        
        request.method
      end

      req.request_uri do
        request.request_uri
      end

      req.host_with_port do
        request.host + request.port.to_s
      end

      req.access_token do
        token_for(req.request_header.token)
      end

      req.access_token_expired? do
        false
      end

      req.request_header do
        request.authorization
      end
    end

    unless oauth_req.validate
      head :unauthorized
    end

    logger.info oauth_req.valid? ? 'VALID' : 'NOT VALID'
  end

  def hello
    @hello = 'SSO is SS with an O.'
  end
end
