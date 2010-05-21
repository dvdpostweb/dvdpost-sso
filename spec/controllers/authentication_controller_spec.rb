require File.dirname(__FILE__) + '/../spec_helper'

# SITE_URL = 'https://localhost:51689'
SITE_URL = 'https://sso.dvdpost.dev'

describe AuthenticationController, "validate token" do
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

describe AuthenticationController, "authorize" do
  it "should redirect to login" do
    get 'authorize'
    response.should_be redirect_to(sign_in_path)
  end

  it "should return a token after authentication"

  it "should redirect to the call back with original URI as param"
end
