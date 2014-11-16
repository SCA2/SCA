require 'rails_helper'

describe User do

  let(:user) { create(:user) } 
  
  subject { user }
  
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  
  it { should be_valid }
  it { should_not be_admin }
  
  describe "with admin attribute set to 'true'" do
    before do
      user.save!
      user.toggle!(:admin)
    end
    
    it { should be_admin }
  end  
  
  # describe "remember token" do
  #   before { user.save }
  #   expect(user.remember_token).not_to be_blank
  # end
  
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
