require "rails_helper"

describe UserMailer do

  before :all do
    @user = create(:user, :password_reset_token => "random")
  end
  
  describe "#password_reset(user)" do

    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password Reset")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["sales@seventhcircleaudio.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("To reset your password, click the link below.")
    end

  end

  describe "#signup_confirmation(user)" do

    let(:mail) { UserMailer.signup_confirmation(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("SCA Signup Confirmation")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["sales@seventhcircleaudio.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Hello " + @user.name)
    end
  end

  # describe "order_received" do
  #   let(:order) { create(:order) }
  #   let(:mail) { UserMailer.order_received(order) }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Thank you for your order")
  #     expect(mail.to).to eq([user.email])
  #     expect(mail.from).to eq(["admin@seventhcircleaudio.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to include("Hello " + user.name)
  #   end
  # end

  describe "#order_shipped(user)" do

    let(:mail) { UserMailer.order_shipped(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your Seventh Circle Audio order has shipped!")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["sales@seventhcircleaudio.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Your order is on its way")
    end
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

end
