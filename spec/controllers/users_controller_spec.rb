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
  
  describe "POST 'create'" do
    before(:each) do
      @atrr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
    end
    
    it "should not create a user" do
      lambda do
        post :create, :user => @attr
      end.should_not change(User, :count)
    end
    
    it "should have the right title" do
      post :create, :user => @attr
      response.should have_selector("title",:content => "Sign up")
    end
    
    it "should render the 'new' page" do
      post :create, :user => @attr
      response.should render_template(:new) #FIXME mal mit :new versuchen !!
    end
    
    describe "on success" do
      before(:each) do
        @attr = {:name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it "should redirect to the users homepage " do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end      
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