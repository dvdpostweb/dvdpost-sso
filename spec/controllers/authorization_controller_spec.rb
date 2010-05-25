require File.dirname(__FILE__) + '/../spec_helper'

# SITE_URL = 'https://localhost:51689'
SITE_URL = 'https://sso.dvdpost.dev'

describe AuthorizationController, "validate token" do
  before(:each) do
    @client = OAuth2::Client.new('124896287520111', '2cfe4006f89205b088eefb7e02e89111', :site => SITE_URL)
  end

  it "should redirect to login with invalid credentials" do
    get 'hello'

    response.status.should be 401
  end

  it "should succeed with valid token" do
    customer = create_customer
    customer.reset_authentication_token!

    headers = {}
    headers['authorization'] = begin
      header = OAuth2::Headers::Authorization.new
      header.token = customer.authentication_token
      header.to_s
    end

    token = OAuth2::AccessToken.new @client, customer.authentication_token
    resp = token.get '/', {}, headers
    response.status.should be 200
  end
end

describe AuthorizationController, "Authorization" do
  context "Client requests authorization" do
    it "should redirect to login when not authenticated" do
      get 'authorize'
      response.should_be redirect_to(sign_in_path)
    end

    it "should return a token when authenticated"

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
