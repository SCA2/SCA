require 'rails_helper'

describe "Authentication" do

  subject { page }

  describe "home page" do

    before { visit home_path }

    it { is_expected.to have_title('Home') }
    it { is_expected.to have_content('Log in') }
    it { is_expected.to have_content('Create Account') }

  end
  
  describe "signin page" do

    before { visit signin_path }
    
    it { is_expected.to have_title('Sign in') }
    it { is_expected.to have_content('Email') }
    it { is_expected.to have_content('Password') }
    it { is_expected.to have_content('Password confirmation') }
    it { is_expected.to have_content('Remember me on this computer') }
    it { is_expected.to have_button('Sign in') }
    it { is_expected.to have_link('Forgot your password?') }
    it { is_expected.not_to have_link('Log out') }

  end
  
  describe "sign in" do
    
    before { visit signin_path }

    describe "with invalid information" do
      
      before { click_button "Sign in" }

      it 'complains with no input' do
        expect(page.body).to include('There are 4 errors on the page')
      end

      describe "after visiting another page" do
        before { click_link "Home" }
        it { is_expected.not_to have_selector('div.alert-box') }
        it { is_expected.not_to have_content('Invalid email or password') }
      end

    end
  
    describe "with valid information" do
      
      let(:user) { create(:user) }
      
      before { test_sign_in(user, use_capybara: true) }

      it { is_expected.to have_title(user.name) }
      it { is_expected.to have_link('My Account',   href: user_path(user)) }
      it { is_expected.to have_link('Edit Profile', href: edit_user_path(user)) }
      it { is_expected.to have_link('Quit',         href: home_path) }
      it { is_expected.to have_link('Log Out',      href: signout_path) }
      it { is_expected.not_to have_link('Log in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Log out" }
        it { is_expected.to have_link("Log In") }
      end
    end
  end
  
  describe "for non-signed-in users" do

    describe "attempting to edit user" do
      let(:user) { create(:user) }
      before { visit edit_user_path(user) }
      it { is_expected.to have_title('Sign in') }
    end

    describe "attempting to view index" do
      let(:user) { create(:user) }
      before { visit users_path }
      it { is_expected.to have_title('Home') }
    end
    
  end
end
