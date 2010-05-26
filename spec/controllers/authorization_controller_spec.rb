require File.dirname(__FILE__) + '/../spec_helper'

# SITE_URL = 'https://localhost:51689'
SITE_URL = 'https://sso.dvdpost.dev'

describe AuthorizationController, "Authorization" do
  before(:each) do
    @client ||= OAuth2::Client.new( 'dvdpost_client',
                                    'dvdpost_client_secret',
                                    :site => SITE_URL,
                                    :authorize_path => 'authorization/new',
                                    :access_token_path => 'authorization/token')
    @redirect_uri ||= 'http://www.dvdpost.be/callback'
  end

  context "Client requests authorization" do
    it "should redirect to login when not authenticated" do
      # Specs currently fail
      Net::HTTP.get(URI.parse(@client.web_server.authorize_url(:redirect_uri => @redirect_uri)))
      puts response
      response.should_be redirect_to(sign_in_path)
    end

    it "should return a token when authenticated" do
      Net::HTTP.get(URI.parse(@client.web_server.authorize_url(:redirect_uri => @redirect_uri)))
      response.should_be redirect_to(@redirect_uri)
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
