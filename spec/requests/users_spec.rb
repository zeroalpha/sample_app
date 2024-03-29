require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in :user_name,     :with => ""
          fill_in :user_email,    :with => ""
          fill_in :user_password, :with => ""
          fill_in :user_password_confirmation, :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User,:count)
      end
    end
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in :user_name,     :with => "Test_user"
          fill_in :user_email,    :with => "test1@rspec.com"
          fill_in :user_password, :with => "rspec123"
          fill_in :user_password_confirmation, :with => "rspec123"
          click_button
          response.should render_template('users/show')
          response.should have_selector('div.flash.success')
        end.should change(User,:count)
      end
    end
  end
end
