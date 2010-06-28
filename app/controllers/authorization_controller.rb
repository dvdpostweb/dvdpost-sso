class AuthorizationController < ApplicationController
  before_filter :verify_token, :only => [:me, :sign_customer_out]

  def new
    if params[:type] == 'web_server'
      if params[:client_id] == 'dvdpost_client'
        if params[:redirect_uri]
          if current_customer
            unless session[:new] or current_customer.valid_tokens?
              current_customer.forget_me!
              current_customer.destroy_tokens!
              sign_out current_customer
            end
          end
          # We're using session[:new] for the redirect (to this action) after authentication. Otherwise it would destroy current_customer all over again.
          session[:new] = true
          authenticate_customer!
          session.delete(:new)
          redirect_to callback_url(params[:redirect_uri], {:code => current_customer.generate_verification_code!})
        else
          render_bad_request :redirect_uri_mismatch
        end
      else
        render_bad_request :invalid_client_credentials
      end
    else
      render_bad_request :invalid_client_type
    end
  end

  def token
    if params[:client_id] == 'dvdpost_client'
      # params[:client_secret] == 'some_secret' # Clients should be reigstered and their secret should be validated too
      case params[:grant_type]
        when 'authorization_code' then authorization_code(params)
        when 'refresh_token'      then refresh_token(params)
        when 'user_basic'         then user_basic(params)
        else render_bad_request :unsupported_grant_type
      end
    else
      render_bad_request :invalid_client_credentials
    end
  end

  def me
    render :status => :ok, :json => {:id => @customer.to_param}
  end

  def sign_customer_out # Should be sign_out but that conflicts with the Devise sign_out helper
    @customer.destroy_tokens!
    render :status => :ok, :json => {:logout => 'ok'}
  end

  private
  def authorization_code(params)
    if params[:redirect_uri] # More secure would be to check if it's a registered redirect_uri
      customer = Customer.find_by_verification_code(params[:code])
      generate_and_return_tokens customer, :invalid_authorization_code
    else
      render_bad_request :redirect_uri_mismatch
    end
  end

  def refresh_token(params)
    customer = Customer.find_by_refresh_token(params[:refresh_token])
    generate_and_return_tokens customer, :invalid_refresh_token
  end

  def user_basic(params)
    if params[:username] && params[:password]
      customer = Customer.find_by_customers_email_address(params[:username])
      if customer && customer.valid_password?(params[:password])
        generate_and_return_tokens customer, :invalid_user_credentials
      else
        render_unauthorized :invalid_user_credentials
      end
    else
      render_bad_request :invalid_user_credentials
    end
  end

  def verify_token
    oauth_token = params[:oauth_token] || params[:access_token] # Current client gem does not support oauth_token yet
    if oauth_token
      @customer = Customer.find_by_authentication_token(oauth_token)
      if @customer
        render_unauthorized :authroziation_expired if @customer.access_token_expired?
      else
        render_unauthorized :invalid_access_token
      end
    else
      render_unauthorized :invalid_access_token
    end
  end

  def generate_and_return_tokens(customer, error_message)
    if customer && customer.update_tokens!
      render :status => :ok, :json => {:access_token => customer.authentication_token, :expires_in => customer.access_token_expires_in, :refresh_token => customer.refresh_token}
    else
      render_unauthorized error_message
    end
  end

  def render_unauthorized(message)
    warden.custom_failure!
    render_error :unauthorized, message
  end

  def render_bad_request(message)
    render_error :bad_request, message
  end

  def render_error(status, message)
    logger.error "*** Error: #{status} => #{message} ***"
    render :status => status, :json => {:error => message}
  end
end
