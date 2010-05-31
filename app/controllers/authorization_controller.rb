require 'oauth2/server'
require 'oauth2/server/request'

class AuthorizationController < ApplicationController
  before_filter :verify_token, :only => [:me]

  def new
    authenticate_customer!
    redirect_to callback_url(params[:redirect_uri], {:code => current_customer.generate_verification_code!})
  end

  def token
    valid_authentication = params[:type] == 'web_server'
    valid_authentication = params[:client_id] == 'dvdpost_client' if valid_authentication
    # valid_authentication = params[:client_secret] == 'dvdpost_client_secret' if valid_authentication  # => not required
    # valid_authentication = params[:redirect_uri] == 'some_uri' if valid_authentication                # => not required
    customer = Customer.find_by_verification_code(params[:code]) if params[:code] && valid_authentication
    valid_authentication = customer if valid_authentication

    if valid_authentication 
      # render :status => :ok, :json => {:access_token => 'some_access_token'}
      # The OAuth2 gem is following an older version of the draft which requires the access_token to be returned as pure text:
      render :status => :ok, :text => "access_token=#{customer.authentication_token}"
    else
      render :status => :bad_request, :json => {:error => 'There was an error trying to retrieve a new token'}
    end
  end

  def me
    render :status => :ok, :json => {:id => current_customer.to_param}
  end

  private
  def verify_token
    current_customer = nil
    # Actually we could have used authenticate_customer! in here since it can validate by the access_token
    # But that would redirect us to the login page which is against the specifications of OAuth2
    # This actually should be oauth_token
    oauth_token = params[:access_token]
    if oauth_token
      current_customer = Customer.find_by_authentication_token(oauth_token)
      unless current_customer
        warden.custom_failure!
        render :status => :unauthorized, :json => {:error => 'Invalid token'}
      end
    else
      warden.custom_failure!
      render :status => :unauthorized, :json => {:error => 'There was no token'}
    end
  end

  def callback_url(uri, params)
    if params.empty?
      uri
    else
      query = params.collect{|k,v| "#{k}=#{v}"}.join('&')
      uri = "#{uri}#{uri.match(/\?/) ? '&' : '?'}"
      "#{uri}#{query}"
    end
  end
end
