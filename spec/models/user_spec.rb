require 'spec_helper'

describe User do
  
  before :each do
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "Foobar",
      :password_confirmation => "Foobar" 
      }

  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
    # invalid_user.valid?.should_not == true
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should limit name-length to 50 Characters" do
    long_name = "X" * 51
    obviously_porn_related_user = User.new(@attr.merge(:name => long_name))
    obviously_porn_related_user.should_not be_valid
  end
  
  

  it "should accept valid email addresses" do
     #FIXME muss ich mir merken, %w<begrenzer> produziert ein array von strings
     addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
     addresses.each do |address|
       valid_email_user = User.new(@attr.merge(:email => address))
       valid_email_user.should be_valid
     end
  end
      
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
    
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
      
  it "it should reject duplicate email ragardless of case" do
    upcase_mail = @attr[:email] = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcase_mail))
    user_with_duplicate_email = User.new(@attr)#User with same lowercase email
    user_with_duplicate_email.should_not be_valid    
  end
  
  describe "password validations" do
    it "should require a apassword" do
      hash = @attr.merge(:password => "",:password_confirmation => "")
      User.new(hash).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      hash = @attr.merge(:password_confirmation => "fail")
      User.new(hash).should_not be_valid
    end
    
    it "should reject short Passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short,:password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject too long Passwords" do
      long = "x" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password atrribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password field" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should return false if the passwords dont match" do
        @user.has_password?("lulu").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil if the password/email combination is wrong" do
        User.authenticate(@attr[:email],"baarfo").should be_nil
      end
      it "should return nil if the user doesnt exist" do
        User.authenticate("bla@blub.su",@attr[:password]).should be_nil
      end
      it "should return a valid user if email/password is correct" do
        User.authenticate(@attr[:email],@attr[:password]).should == @user
      end
      
    
    end
    
  end
 

end
