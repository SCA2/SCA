require 'spec_helper'

describe "Authentication" do

  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    
    it { should have_title('Sign in') }
    it { should have_content('Sign in') }
    it { should have_content('Email:') }
    it { should have_content('Password:') }
    it { should have_content('Confirm:') }
    it { should have_button('Sign in') }

  end
end
