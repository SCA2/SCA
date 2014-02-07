require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  describe "user profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_title(user.name) }
    it { should have_content('User Details') }
    it { should have_field("Name:", :with => user.name) }
    it { should have_field("Email:", :with => user.email) }
  end
  
  describe "signup page" do
    before { visit signup_path }
    
    it { should have_title('Sign up') }
    it { should have_content('Sign up') }
    it { should have_content('Name:') }
    it { should have_content('Email:') }
    it { should have_content('Password:') }
    it { should have_content('Confirm:') }
    it { should have_button('Create User') }
  end
  
  describe "signup" do

    before { visit signup_path }

    let(:submit) { 'Create User' }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",     with: "Example User"
        fill_in "Email",    with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm",  with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      it "should redirect to user profile" do
        click_button submit 
        current_path should have_field("Name:", :with => "Example User")
      end
    end
  end
end
