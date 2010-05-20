require File.dirname(__FILE__) + '/../spec_helper'

describe AuthenticationController, "oauth2 verify request" do
  before(:each) do
    @client = OAuth2::Client.new('124896287520111', '2cfe4006f89205b088eefb7e02e89111', :site => 'https://dvdpost-sso.dev')
  end

  it "should fail with invalid credentials" do
    get 'hello'

    response.should_not be_success
    response.status.should be 401
  end

  it "should succeed with valid token" do
    headers = {}
    headers['Authorization'] =  <<-EOS
      Token token="vF9dft4qmT",
            nonce="s8djwd",
            timestamp="137131200",
            algorithm="hmac-sha256",
            signature="ZSPk4B37TjHu3/yyu31LD7/agpzPjhYQEszZk7GdEfs="
    EOS

    token = OAuth2::AccessToken.new @client, "vF9dft4qmT"

    resp = token.get '/', {}, headers
    
    response.status.should_not be 401
  end

  it "should return a token after authentication" do
    @client
  end
#
#  it "should redirect to redirect uri"
end
