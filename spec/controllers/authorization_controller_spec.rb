require File.dirname(__FILE__) + '/../spec_helper'

# SITE_URL = 'http://localhost:60751'
SITE_URL = 'https://sso.dvdpost.dev'

describe AuthorizationController, "Authorization" do
  include Devise::TestHelpers

  before(:each) do
    @client ||= OAuth2::Client.new( 'dvdpost_client',
                                    'dvdpost_client_secret',
                                    :site => SITE_URL,
                                    :authorize_path => 'authorization/new',
                                    :access_token_path => 'authorization/token')
    @type ||= 'web_server'
    @client_id ||= 'dvdpost_client'
    @redirect_uri ||= 'http://dvdpost.dev/callback'
    @valid_start_params ||= {:type => @type, :client_id => @client_id, :redirect_uri => @redirect_uri}
  end

  context "Client requests authorization" do
    it "should throw an error 'invalid_client_type' if no type param was given" do
      get :new, :client_id => @client_id, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_type'
    end

    it "should throw an error 'invalid_client_credentials' if no client_id param was given" do
      get :new, :type => @type, :redirect_uri => @redirect_uri
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'invalid_client_credentials'
    end

    it "should throw an error 'redirect_uri_mismatch' if no redirect_uri param was given" do
      get :new, :type => @type, :client_id => @client_id
      response.should be_bad_request
      JSON.parse(response.body)['error'].should == 'redirect_uri_mismatch'
    end

    it "should redirect to login when not authenticated" do
      # get :new, @valid_start_params
      # puts response.body
      # response.should redirect_to(new_customer_session_path)
    end

    it "should return a token when authenticated" do
      # get :new, @valid_start_params
      # response.should redirect_to(@redirect_uri)
    end

    it "should return error=user_denied if user denied"

    it "should redirect to the callback with a verification code in the params"
  end

  context "Client Requests Access Token" do
    it "should return an access token with valid params"

    it "should return an error redirect_uri_mismatch when a wrong redirect_uri is given"

    it "should return an error bad_verification_code when a wrong verification_code is given"

    it "should return an error incorrect_client_credentials when a wrong client_id is given"
  end

  context "Client Refreshes Access Token" do
    it "should return a new access_token when valid params"

    it "should return an error incorrect_client_credientials when a wrong client_id is given"

    it "should return an error authorization_expired when authorization is expired"

    it "should return an error unsupported_secret_type when a wrong secret_type is given"
  end
end
