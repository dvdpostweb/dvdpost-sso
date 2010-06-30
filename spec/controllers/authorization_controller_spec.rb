require File.dirname(__FILE__) + '/../spec_helper'

describe AuthorizationController, "Authorization" do
  include Devise::TestHelpers

  before(:each) do
    @type ||= 'web_server'
    @client_id ||= 'dvdpost_rspec_client'
    @client_secret ||= 'dvdpost_rspec_client_secret'
    @redirect_uri ||= 'http://dvdpost.dev/callback'
    @username ||= 'customer@dvdpost.dev'
    @password ||= 'secret'

    @invalid_type ||= 'invalid_type'
    @invalid_client_id ||= 'invalid_client_id'
    @invalid_client_id ||= 'invalid_client_secret'
    @invalid_redirect_uri ||= 'http://dvdpost.dev.hacker.dev/callback'
    @malformed_redirect_uri ||= 'malformed://dvdpostdev/callback'

    @valid_start_params ||= {:type => @type, :client_id => @client_id, :client_secret => @client_secret, :redirect_uri => @redirect_uri}
    @valid_authorization_code_params ||= {:grant_type => 'authorization_code', :client_id => @client_id, :client_secret => @client_secret, :redirect_uri => @redirect_uri}
    @valid_refresh_token_params ||= {:grant_type => 'refresh_token', :client_id => @client_id, :client_secret => @client_secret}
    @valid_user_basic_params ||= {:grant_type => 'user_basic', :client_id => @client_id, :client_secret => @client_secret}

    Customer.destroy_all
    @customer = Customer.new
    @customer.update_attribute :email, @username
    @customer.update_attribute :password, '5ebe2294ecd0e0f08eab7690d2a6ee69' # => secret
  end

  context "new" do
    it "should throw an error 'invalid_client_type' if no type param was given" do
      get :new, :client_id => @client_id, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_type'
    end

    it "should throw an error 'invalid_client_type' if an invalid type param was given" do
      get :new, :type => @invalid_type, :client_id => @client_id, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_type'
    end

    it "should throw an error 'invalid_client_credentials' if no client_id was given" do
      get :new, :type => @type, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'invalid_client_credentials' if an invalid client_id was given" do
      get :new, :type => @type, :client_id => @invalid_client_id, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'invalid_client_credentials' if no client_secret was given" do
      get :new, :type => @type, :client_id => @client_id, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'invalid_client_credentials' if an invalid client_id was given" do
      get :new, :type => @type, :client_id => @client_id, :client_secret => @invalid_client_secret, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end


    it "should throw an error 'redirect_uri_mismatch' if no redirect_uri was given" do
      get :new, :type => @type, :client_id => @client_id, :client_secret => @client_secret
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end

    it "should throw an e rror 'redirect_uri_mismatch' if an incorrect redirect_uri was given" do
      get :new, :type => @type, :client_id => @client_id, :client_secret => @client_secret, :redirect_uri => @invalid_redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end


    it "should throw an e rror 'redirect_uri_mismatch' if a malformed redirect_uri was given" do
      get :new, :type => @type, :client_id => @client_id, :client_secret => @client_secret, :redirect_uri => @malformed_redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end

    it "should redirect to login when the customer is not authenticated" do
      pending "Fails because of an error: \"undefined method `generate_verification_code!' for nil:NilClass\""
      get :new, @valid_start_params
      response.should redirect_to(new_customer_session_path)
    end

    it "should redirect to redirect_uri with an authorization code when the customer is authenticated" do
      pending "Fails because of an error: \"Render and/or redirect were called multiple times in this action. Please note that you may only call render OR redirect, and at most once per action. Also note that neither redirect nor render terminate execution of the action, so if you want to exit an action after redirecting, you need to do something like \"redirect_to(...) and return\".\""
      sign_in @customer
      get :new, @valid_start_params
      response.should redirect_to(@redirect_uri)
    end
  end

  context "generate a new token" do
    it "should throw an error 'invalid_client_credentials' if no client_id was given" do
      post :token
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'invalid_client_credentials' if an invalid client_id was given" do
      post :token, :client_id => @invalid_client_id
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'invalid_client_credentials' if no client_secret was given" do
      post :token
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'invalid_client_credentials' if an invalid client_secret was given" do
      post :token, :client_secret => @invalid_secret
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'unsupported_grant_type' if no grant_type was given" do
      post :token, :client_id => @client_id, :client_secret => @client_secret
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'unsupported_grant_type'
    end

    it "should throw an error 'unsupported_grant_type' if an invalid grant_type was given" do
      post :token, :client_id => @client_id, :client_secret => @client_secret, :grant_type => 'invalid_grant_type'
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'unsupported_grant_type'
    end
  end

  context "generate a new token with an authorization code" do
    it "should throw an error 'redirect_uri_mismatch' if no redirect_uri was given" do
      post :token, :grant_type => 'authorization_code', :client_id => @client_id, :client_secret => @client_secret
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end

    it "should thrown an error 'redirect_uri_mismatch' if an incorrect redirect_uri was given" do
      post :token, :grant_type => 'authorization_code', :client_id => @client_id, :client_secret => @client_secret, :redirect_uri => @invalid_redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end

    it "should thrown an error 'invalid_authorization_code' if an incorrect authorization_code was given" do
      @customer.generate_verification_code!
      post :token, @valid_authorization_code_params.merge(:code => 'invalid_authorization_code')
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_authorization_code'
    end

    it "should return an access token and no expires_in or refresh_token if a correct authorization_code was given and remember_me was not checked" do
      @customer.generate_verification_code!
      post :token, @valid_authorization_code_params.merge(:code => @customer.verification_code)
      response.should be_ok
      customer = Customer.find(@customer.to_param)
      JSON.parse(response.body)['access_token'].should == customer.authentication_token
      JSON.parse(response.body)['expires_in'].should == 0
      JSON.parse(response.body)['refresh_token'].should be_nil
    end

    it "should return an access token, refresh token and expiry date if a correct authorization_code was given and remember_me was checked" do
      @customer.remember_me!
      @customer.generate_verification_code!
      post :token, @valid_authorization_code_params.merge(:code => @customer.verification_code)
      response.should be_ok
      customer = Customer.find(@customer.to_param)
      JSON.parse(response.body)['access_token'].should == customer.authentication_token
      JSON.parse(response.body)['expires_in'].should > 0
      JSON.parse(response.body)['refresh_token'].should == customer.refresh_token
    end
  end

  context "generate a new token with a refresh token" do
    it "should thrown an error 'invalid_refresh_token' if no refresh_token was given" do
      @customer.update_tokens!
      post :token, @valid_refresh_token_params
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_refresh_token'
    end

    it "should thrown an error 'invalid_refresh_token' if an incorrect refresh_token was given" do
      @customer.update_tokens!
      post :token, @valid_refresh_token_params.merge(:refresh_token => 'invalid_refresh_token')
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_refresh_token'
    end

    it "should thrown an error 'invalid_refresh_token' if an expired refresh_token was given" do
      @customer.update_tokens!
      @customer.update_attribute(:refresh_token_expires_at, 1.day.ago)
      post :token, @valid_refresh_token_params.merge(:refresh_token => @customer.refresh_token)
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_refresh_token'
    end

    it "should thrown an error 'invalid_refresh_token' if a correct refresh_token was given and remember_me was not checked" do
      @customer.update_tokens!
      post :token, @valid_refresh_token_params.merge(:refresh_token => @customer.refresh_token)
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_refresh_token'
    end

    it "should return an access token, refresh token and expiry date if a correct refresh_token was given and remember_me was checked" do
      @customer.remember_me!
      @customer.update_tokens!
      post :token, @valid_refresh_token_params.merge(:refresh_token => @customer.refresh_token)
      response.should be_ok
      customer = Customer.find(@customer.to_param)
      JSON.parse(response.body)['access_token'].should == customer.authentication_token
      JSON.parse(response.body)['expires_in'].should  > 0
      JSON.parse(response.body)['refresh_token'].should == customer.refresh_token
    end
  end

  context "generate a new token with resource owner basic credentials" do
    it "should throw an error 'invalid_user_credentials' if no username was given" do
      post :token, @valid_user_basic_params.merge(:password => @password)
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_user_credentials'
    end

    it "should throw an error 'invalid_user_credentials' if no password was given" do
      post :token, @valid_user_basic_params.merge(:username => @username)
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_user_credentials'
    end

    it "should throw an error 'invalid_user_credentials' if an incorrect username and/or password was given" do
      post :token, @valid_user_basic_params.merge(:username => 'incorrect_username', :password => 'incorrect_password')
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_user_credentials'
    end

    it "should return an access token, refresh token and expiry date if a correct username and password were given" do
      post :token, @valid_user_basic_params.merge(:username => @username, :password => @password)
      tokens =  JSON.parse(response.body)
      customer = Customer.find_by_customers_email_address(@username)
      tokens['access_token'].should == customer.authentication_token
      tokens['refresh_token'].should == customer.refresh_token
    end
  end

  context "access a protected resource" do
    it "should throw an error 'invalid_access_token' if no oauth_token was given" do
      get :me
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_access_token'
    end

    it "should throw an error 'invalid_access_token' if an invalid oauth_token was given" do
      @customer.update_tokens!
      get :me, :oauth_token => 'invalid_oauth_token'
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_access_token'
    end

    it "should throw an error 'authroziation_expired' if an expired oauth_token was given" do
      @customer.update_tokens!
      @customer.update_attribute(:access_token_expires_at, 1.day.ago.to_s(:db))
      get :me, :oauth_token => 'expired_oauth_token'
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_access_token'
    end
  end

  context "get customer's id after verifying the request" do
    it "should return the requested data if a valid oauth_token was given" do
      @customer.update_tokens!
      get :me, :oauth_token => @customer.authentication_token
      response.should be_ok
      JSON.parse(response.body)['id'].should == @customer.to_param
    end
  end

  context "sign the customer out" do
    it "should sign out when a valid oauth_token was given" do
      @customer.update_tokens!
      post :sign_customer_out, :oauth_token => @customer.authentication_token
      response.should be_ok
      JSON.parse(response.body)['logout'].should == 'ok'
    end
  end
end
