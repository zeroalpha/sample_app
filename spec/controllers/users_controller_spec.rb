require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    it "should be successfull" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
    it "should rfind the right user" do
      get :show, :id => @user.id
      response.should be_success
    end
    it "should have the right title" do
      get :show, :id => @user.id
      response.should have_selector("title", :content => @user.name)
    end
    it "should have the users name in the <h1>" do
      get :show, :id => @user.id
      response.should have_selector("h1",:content => @user.name)
    end
    it "should have a profile iamge" do
      get :show, :id => @user.id
      response.should have_selector("h1>img",:class => "gravatar")
    end
  end   
  
end