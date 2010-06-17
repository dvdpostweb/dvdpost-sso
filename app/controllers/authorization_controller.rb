class AuthorizationController < ApplicationController
  before_filter :verify_token, :only => [:me]

  def new
    authenticate_customer!
    redirect_to callback_url(params[:redirect_uri], {:code => current_customer.generate_verification_code!})
  end

  def token
    if params[:type] == 'web_server'
      if params[:client_id] == 'dvdpost_client'
        # params[:client_secret] == 'dvdpost_client_secret' # => not required
        # params[:redirect_uri] == 'some_uri'               # => not required (error code = redirect_uri_mismatch)
        customer = Customer.find_by_verification_code(params[:code])
        if customer && customer.reset_authentication_token!
          render :status => :ok, :json => {:access_token => customer.authentication_token}
        else
          render_bad_request 'There was a problem trying to retrieve a new token'
        end
      else
        render_bad_request 'client_id_mismatch'
      end
    else
      render_bad_request 'unsupported_type'
    end
  end

  def me
    render :status => :ok, :json => {:id => current_customer.to_param}
  end

  def logout
    current_customer.destroy_token!
    sign_out(current_customer)
    redirect_to 'http://www.dvdpost.be'
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
        render_unauthorized 'invalid_token'
      end
    else
      warden.custom_failure!
      render_unauthorized 'invalid_token'
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

  def render_unauthorized(message)
    render_error :unauthorized, message
  end

  def render_bad_request(message)
    render_error :bad_request, message
  end

  def render_error(status, message)
    render :status => status, :json => {:error => message}
  end
end
