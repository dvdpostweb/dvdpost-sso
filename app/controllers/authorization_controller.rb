class AuthorizationController < ApplicationController
  include AuthorizationHelper
  before_filter :verify_token, :only => [:me, :sign_customer_out, :remember_me]

  def new
    validate_type do
      validate_client do
        validate_redirect_uri do
          if current_customer
            session.delete(:customer_return_to)
            unless session[:new] or current_customer.valid_tokens?
              current_customer.forget_me!
              current_customer.destroy_tokens!
              sign_out current_customer
            end
          end
          if params[:action_type] == 'registration'
            params.delete(:action_type)
            url = request.fullpath
            url['&action_type=registration']=''
            session[:customer_return_to] = url
            session[:new] = true
            path = new_customer_registration_path(:promotion => params[:promotion], :p_id => params[:p_id], :site => params[:site])
          else
            # We're using session[:new] for the redirect (to this action) after authentication. Otherwise it would destroy current_customer all over again.
            session[:new] = true
            authenticate_customer!
            session.delete(:new)
          end
          
          if path
            redirect_to path
          else
            redirect_to callback_url(params[:redirect_uri], {:code => current_customer.generate_verification_code!, :locale => current_locale})
          end
        end
      end
    end
  end

  def token
    validate_client do
      case params[:grant_type]
        when 'authorization_code' then authorization_code(params)
        when 'refresh_token'      then refresh_token(params)
        when 'user_basic'         then user_basic(params)
        else render_bad_request :unsupported_grant_type
      end
    end
  end

  def me
    render :status => :ok, :json => {:id => @customer.to_param}
  end

  def sign_customer_out # Should be sign_out but that conflicts with the Devise sign_out helper
    @customer.destroy_tokens!
    render :status => :ok, :json => {:logout => 'ok'}
  end

  def remember_me
    redirect_uri = params[:redirect_uri]
    if redirect_uri
      sign_in(@customer)
      authenticate_customer!
      redirect_to redirect_uri
    else
      render_bad_request :invalid_redirect_uri
    end
  end

  private
  def authorization_code(params)
    validate_redirect_uri do
      if params[:code] && !params[:code].empty?
        customer = Customer.find_by_verification_code(params[:code])
        generate_and_return_tokens customer, :invalid_authorization_code
      else
        render_unauthorized :invalid_authorization_code
      end
    end
  end

  def refresh_token(params)
    if params[:refresh_token] && !params[:refresh_token].empty?
      customer = Customer.find_by_refresh_token(params[:refresh_token])
      if customer && customer.refresh_token_expired?
        render_bad_request :invalid_refresh_token
      else
        generate_and_return_tokens customer, :invalid_refresh_token
      end
    else
      render_unauthorized :invalid_refresh_token
    end
  end

  def user_basic(params)
    if params[:username] && params[:password]
      customer = Customer.find_by_customers_email_address(params[:username])
      if customer && customer.valid_password?(params[:password])
        customer.remember_me!
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
end
