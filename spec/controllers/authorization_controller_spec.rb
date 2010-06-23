require File.dirname(__FILE__) + '/../spec_helper'

# SITE_URL = 'http://localhost:60751'
SITE_URL = 'https://sso.dvdpost.dev'

describe AuthorizationController, "Authorization" do
  include Devise::TestHelpers

  before(:each) do
    @type ||= 'web_server'
    @client_id ||= 'dvdpost_client'
    @redirect_uri ||= 'http://dvdpost.dev/callback'

    @invalid_type ||= 'invalid_type'
    @invalid_client_id ||= 'invalid_client_id'
    @invalid_redirect_uri ||= 'http://my_hack_site.dev/callback'
    @malformed_redirect_uri ||= 'malformed://dvdpost.dev/callback'

    @valid_start_params ||= {:type => @type, :client_id => @client_id, :redirect_uri => @redirect_uri}
    @valid_authorization_code_params ||= {:client_id => @client_id, :grant_type => 'authorization_code', :redirect_uri => @redirect_uri}
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
      get :new, :client_id => @invalid_client_id, :type => @type, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'redirect_uri_mismatch' if no redirect_uri was given" do
      get :new, :type => @type, :client_id => @client_id
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end

    it "should throw an e rror 'redirect_uri_mismatch' if an incorrect redirect_uri was given" do
      pending "This is not yet validated in the code"
      get :new, :type => @type, :client_id => @client_id, :redirect_uri => @invalid_redirect_uri
    end


    it "should throw an e rror 'redirect_uri_mismatch' if a malformed redirect_uri was given" do
      pending "This is not yet validated in the code"
      get :new, :type => @type, :client_id => @client_id, :redirect_uri => @malformed_redirect_uri
    end

    it "should redirect to login when the customer is not authenticated" do
      pending "Fails because of an error: \"undefined method `generate_verification_code!' for nil:NilClass\""
      get :new, @valid_start_params
      response.should redirect_to(new_customer_session_path)
    end

    it "should redirect to redirect_uri with an authorization code when the customer is authenticated" do
      pending "Fails because of an error: \"undefined method `generate_verification_code!' for nil:NilClass\""
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

    it "should throw an error 'unsupported_grant_type' if no grant_type was given" do
      post :token, :client_id => @client_id
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'unsupported_grant_type'
    end
  end

  context "generate a new token with an authorization code" do
    it "should throw an error 'redirect_uri_mismatch' if no redirect_uri was given" do
      post :token, :client_id => @client_id, :grant_type => 'authorization_code'
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end

    it "should thrown an error 'redirect_uri_mismatch' if an incorrect redirect_uri was given" do
      pending "Validation on redirect_uri's is not implemented."
    end

    it "should thrown an error 'invalid_authorization_code' if an incorrect authorization_code was given" do
      pending "Fails because this requires access to the database we cannot provide because of this legacy database"
      post :token, @valid_authorization_code_params.merge(:authorization_code => 'invalid_authorization_code')
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_authorization_code'
    end

    it "should return an access token, refresh token and expiry date if a correct authorization_code was given" do
      pending "Fails because this requires access to the database we cannot provide because of this legacy database"
      post :token, @valid_authorization_code_params.merge(:authorization_code => 'valid_authorization_code')
    end
  end

  context "generate a new token with a refresh token" do
    it "should thrown an error 'invalid_refresh_token' if an incorrect refresh_token was given" do
      pending "Fails because this requires access to the database we cannot provide because of this legacy database"
      post :token, @valid_authorization_code_params.merge(:refresh_token => 'invalid_refresh_token')
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_refresh_token'
    end

    it "should thrown an error 'invalid_refresh_token' if an expired refresh_token was given" do
      pending "Fails because this requires access to the database we cannot provide because of this legacy database"
      post :token, @valid_authorization_code_params.merge(:refresh_token => 'expired_refresh_token')
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_refresh_token'
    end

    it "should return an access token, refresh token and expiry date if a correct refresh_token was given" do
      pending "Fails because this requires access to the database we cannot provide because of this legacy database"
      post :token, @valid_authorization_code_params.merge(:refresh_token => 'valid_refresh_token')
    end
  end
end
