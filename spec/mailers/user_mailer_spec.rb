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

# shared_examples "a well tested mailer" do
#  2   let(:greeting) { "Darren" }
#  3   let(:full_subject) { "#{asserted_subject}:You got mail!" }
#  4   let(:mail) { mailer_class.email(greeting) }
#  5 
#  6   it "renders the headers" do
#  7     mail.content_type.should start_with('multipart/alternative') #html / text support
#  8   end
#  9 
# 10   it "sets the correct subject" do
# 11     mail.subject.should eq(full_subject)
# 12   end
# 13 
# 14   it "includes asserted_body in the body of the email" do
# 15     asserted_body.each do |content|
# 16       mail.body.encoded.should match(content)
# 17     end
# 18   end
# 19 
# 20   it "should be from 'from@example.com'" do
# 21     mail.from.should include('from@example.com')
# 22   end
# 23 end

# 1 describe CoolMailer do
#  2   describe "email" do
#  3     let(:mailer_class) { CoolMailer }
#  4     let(:asserted_subject) { "A cool mail!" }
#  5     let(:asserted_body) { ["This content", "That content"] }
#  6 
#  7     it_behaves_like "a well tested mailer" do
#  8     end
#  9   end
# 10 end