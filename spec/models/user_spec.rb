require 'rails_helper'

describe User do

  let(:user) { create(:user) } 
  
  subject { user }
  
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to have_attributes(:remember_token => a_value) }
  it { is_expected.to respond_to(:authenticate) }
  it { is_expected.to respond_to(:admin) }
  
  it { is_expected.to be_valid }
  it { is_expected.not_to be_admin }
  
  describe "with admin attribute set to 'true'" do
    before do
      user.save!
      user.toggle!(:admin)
    end
    
    it { is_expected.to be_admin }
  end  
  
  describe "#send_password_reset" do

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      expect(user.password_reset_token).not_to eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      expect(user.reload.password_reset_sent_at).to be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      expect(last_email.to_s).to include("To: #{user.email}")
    end

  end
end
