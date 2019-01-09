require 'rails_helper'

describe "User pages" do
  
  subject { page }
  
  describe "Admin" do

    let(:admin) { create(:admin) }
    before(:each) do
      test_sign_in(admin, use_capybara: true)
      visit admin_path
    end

    it { is_expected.to have_title('Site Admin') }
    it { is_expected.to have_content('Users') }
    it { is_expected.to have_content('Orders') }

  end

  describe "All Users" do

    let(:admin) { create(:admin) }

    before(:each) do
      test_sign_in(admin, use_capybara: true)
      visit users_path
    end

    before(:all) { 30.times { create(:user) } }
    after(:all)  { User.delete_all }
  
    it { is_expected.to have_title('All Users') }
    it { is_expected.to have_link('delete') }

  end

  describe "pagination" do

    let(:admin) { create(:admin) }

    before(:each) do
      test_sign_in(admin, use_capybara: true)
      visit users_path
    end

    before(:all) { 30.times { create(:user) } }
    after(:all)  { User.delete_all }

    it { is_expected.to have_selector('div.pagination') }

    it "should list each user" do
      User.paginate(page: 1).each do |user|
        expect(page).to have_selector('td', text: user.name)
      end
    end
  end
    
  describe "delete" do

    let(:admin) { create(:admin) }

    before(:each) do
      test_sign_in(admin, use_capybara: true)
      visit users_path
    end

    before(:all) { 30.times { create(:user) } }
    after(:all)  { User.delete_all }

    it { is_expected.to have_link('delete', href: user_path(User.first)) }
    it "should be able to delete a user" do
      expect { click_link('delete', match: :first) }.to change(User, :count).by(-1)
    end
    it "does not have a link to delete admin" do
      is_expected.not_to have_link('delete', href: user_path(admin))
    end
  end
  
  describe "user profile page" do
    
    let(:user) { build(:user) }
    before(:each) do
      user.addresses << build(:address, address_type: 'billing')
      user.addresses << build(:address, address_type: 'shipping')
      user.save!
      test_sign_in(user, use_capybara: true)
      visit user_path(user)
    end

    it { is_expected.to have_title(user.name) }
    it { is_expected.to have_text('User') }
    it { is_expected.to have_text('Contact Preferences') }
    it { is_expected.to have_text('Billing Address') }
    it { is_expected.to have_text('Shipping Address') }
    it { is_expected.to have_text(user.name) }
    it { is_expected.to have_text(user.email) }
  end
  
  describe "signup page" do
    
    before { visit signup_path }
    
    it { is_expected.to have_title('Sign up') }
    it { is_expected.to have_content('Sign up') }
    it { is_expected.to have_content('Name') }
    it { is_expected.to have_content('Email') }
    it { is_expected.to have_content('Password') }
    it { is_expected.to have_content('Password confirmation') }
    it { is_expected.to have_content('Contact Preferences') }
    it { is_expected.to have_content('Billing Address') }
    it { is_expected.to have_content('Shipping Address') }
    it { is_expected.to have_button('Create Account') }
  end
  
  describe "signup" do

    before { visit signup_path }

    let(:submit) { 'Create Account' }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    
      describe "after submission" do
        before { click_button submit }

        it { is_expected.to have_title('Sign up') }
        it { is_expected.to have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",     with: "Example User"
        fill_in "Email",    with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation",  with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { is_expected.to have_link('Log Out') }
        it { is_expected.to have_title(user.name) }
        it { is_expected.to have_content('Signed up!') }
      end
    end
  end
  
  describe "edit" do
    
    let(:user) { create(:user) }
    
    before do
      test_sign_in(user, use_capybara: true)
      visit edit_user_path(user)
    end

    describe "page" do
      it { is_expected.to have_title("Update profile") }
      it { is_expected.to have_content("Update your profile") }
      it { is_expected.to have_content("Contact Preferences") }
      it { is_expected.to have_content("Billing Address") }
      it { is_expected.to have_content("Shipping Address") }
    end

    describe "with valid data" do

      let(:new_user)  { build(:user) }

      before do
        fill_in "Name",      with: new_user.name
        fill_in "Email",     with: new_user.email
        fill_in "Password",  with: user.password
        fill_in "Password confirmation",   with: user.password
        click_button "Save changes"
      end

      it { is_expected.to have_title(new_user.name) }
      it { is_expected.to have_content('Profile updated!') }
      it { is_expected.to have_link('Log Out', href: signout_path) }
      it { expect(user.reload.name).to  eq new_user.name }
      it { expect(user.reload.email).to eq new_user.email }

    end
    
    describe "with invalid data" do

      before do
        fill_in "Name",      with: 'a'
        fill_in "Email",     with: 'a@.com'
        fill_in "Password",  with: 'b'
        fill_in "Password confirmation",   with: 'c'
        click_button "Save changes"
      end

      it { is_expected.to have_title('Update profile') }
      it { is_expected.to have_content("Logged in as #{user.email}") }
      it { is_expected.to have_link('Log Out', href: signout_path) }
      it { is_expected.to have_content('There are 3 errors on the page:') }

    end
  end
end
