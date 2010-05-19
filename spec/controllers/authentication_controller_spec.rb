require File.dirname(__FILE__) + '/../spec_helper'

describe AuthenticationController, "oauth2 verify request unauthenticated" do
#  before(:each) do
#    MenuItem.stub!(:new).and_return(@menu_item = mock_model(MenuItem, :save=>true))
#  end

  it "should fail authentication" do
    get 'hello'
  end
#
#  it "should save the menu item" do
#    @menu_item.should_receive(:save).and_return(true)
#    do_create
#  end
#
#  it "should be redirect" do
#    do_create
#    response.should be_redirect
#  end
#
#  it "should assign menu_item" do
#    do_create
#    assigns(:menu_item).should == @menu_item
#  end
#
#  it "should redirect to the index path" do
#    do_create
#    response.should redirect_to(menu_items_url)
#  end
end
