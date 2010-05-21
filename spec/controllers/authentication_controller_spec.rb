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
    headers = {}
    # headers['Authorization'] =  <<-EOS
    #   Token token="vF9dft4qmT",
    #         nonce="s8djwd",
    #         timestamp="137131200",
    #         algorithm="hmac-sha256",
    #         signature="ZSPk4B37TjHu3/yyu31LD7/agpzPjhYQEszZk7GdEfs="
    # EOS

    headers['authorization'] = begin
      header = OAuth2::Headers::Authorization.new
      header.token = 'vF9dft4qmT'
      header.to_s
    end

    token = OAuth2::AccessToken.new @client, "vF9dft4qmT"    
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
