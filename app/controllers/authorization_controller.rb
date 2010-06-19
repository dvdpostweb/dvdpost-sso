class AuthorizationController < ApplicationController
  before_filter :verify_token, :only => [:me]

  def new
    authenticate_customer!
    redirect_to callback_url(params[:redirect_uri], {:code => current_customer.generate_verification_code!})
  end

  def token
    if params[:client_id] == 'dvdpost_client'
      case params[:grant_type]
      when 'authorization_code' then authorization_code(params)
      when 'refresh_token'      then refresh_token(params)
      else render_bad_request 'unsupported_grant_type'
      end  
    else
      render_bad_request 'client_id_mismatch'
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
  def authorization_code(params)
    # params[:client_secret] == 'dvdpost_client_secret' # => not required
    # params[:redirect_uri] == 'some_uri'               # => not required (error code = redirect_uri_mismatch)
    customer = Customer.find_by_verification_code(params[:code])
    if customer && customer.reset_authentication_token!
      render :status => :ok, :json => {:access_token => customer.authentication_token, :expires_in => 1209600, :refresh_token => customer.remember_token}
    else
      render_bad_request 'There was a problem trying to retrieve a new token.'
    end
  end

  def refresh_token(params)
    customer = Customer.find_by_remember_token(params[:refresh_token])
    if customer
      logger.info "*** Should generate a new access token here! ***"
      # Generate a new access token
      render :status => :ok, :json => {:access_token => customer.authentication_token, :expires_in => 1209600, :refresh_token => customer.remember_token}
    else
      render_bad_request 'There was a problem trying to retrieve a new token.'
    end
  end

  def verify_token
    # Actually we could have used authenticate_customer! in here since it can validate by the access_token
    # But that would redirect us to the login page which is against the specifications of OAuth2
    # This actually should be oauth_token
    oauth_token = params[:access_token]
    if oauth_token
      unless current_customer == Customer.find_by_authentication_token(oauth_token)
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
