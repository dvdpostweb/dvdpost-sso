require 'oauth2/server'
require 'oauth2/server/request'

class AuthorizationController < ApplicationController
  def new
    authenticate_customer!
    redirect_to callback_url(params[:redirect_uri], {:code => current_customer.authentication_token})
  end

  def token
    valid_token = params[:type] == 'web_server'
    valid_token = params[:client_id] == 'dvdpost_client' if valid_token
    valid_token = params[:client_secret] == 'dvdpost_client_secret' if valid_token
    valid_token = params[:redirect_uri] == 'some_uri' if valid_token
    valid_token = params[:code] == 'code generated in authorization#new' if valid_token

    valid_token = true # for testing

    if valid_token
      # render :status => :ok, :json => {:access_token => 'some_access_token'}
      # The OAuth2 gem is following an older version of the draft which requires the access_token to be returned as pure text:
      render :status => :ok, :text => 'access_token=some_access_token'
    else
      render :status => :bad_request, :json => {:error => 'error_description'}
    end
  end

  # This is only used for test purposes
  def hello
    authenticate_customer!
    @hello = 'SSO is SS with an O.'
  end

  private
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
