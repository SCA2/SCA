require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All Users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
        it "should not be able to delete itself" do
          expect do
            page.driver.submit :delete, user_path(admin), {}
          end.not_to change(User, :count).by(-1)
#          expect do
#            page.driver.submit :delete, user_path(admin), {}
#          end.to have_content("Can't delete yourself!")
        end
      end
    end
  end
  
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
    it { should have_button('Sign up') }
  end
  
  describe "signup" do

    before { visit signup_path }

    let(:submit) { 'Sign up' }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
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
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert-box.success', text: 'Signed up!') }
      end
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_title("Update profile") }
      it { should have_content("Update your profile") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name:",      with: new_name
        fill_in "Email:",     with: new_email
        fill_in "Password:",  with: user.password
        fill_in "Confirm:",   with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert-box') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
    
    describe "forbidden attributes", type: :request do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end
