require 'rails_helper'

describe CardTokenizer do

  let(:order) { build(:order) }
  
  subject { CardTokenizer.new(order, {}) }
  
  it { should respond_to(:stripe_token) }
  it { should respond_to(:email) }
  it { should respond_to(:ip_address) }
  it { should respond_to(:name_on_card) }
  it { should respond_to(:address) }

  describe 'save' do
    it 'updates the order' do

      @params = {
        stripe_token: 'token',
        email: 'joe.tester@example.com',
        ip_address: '127.0.0.1',
      }

      CardTokenizer.new(order, @params).save
      expect(order.stripe_token).to eq @params[:stripe_token]
      expect(order.email).to eq @params[:email]
      expect(order.ip_address).to eq @params[:ip_address]
    end
  end

end