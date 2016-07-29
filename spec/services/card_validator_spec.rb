require 'rails_helper'

describe CardValidator do

  let(:order) { build_stubbed(:order) }
  @params ||= {
    card_type: 'visa',
    card_number: '1234567812345678',
    card_verification: 123,
    email: 'joe.tester@example.com',
    ip_address: '127.0.0.1',
    card_expires_on: 1.year.from_now
  }

  subject { CardValidator.new(order, @params) }
  
  it { should respond_to(:card_type) }
  it { should respond_to(:card_number) }
  it { should respond_to(:card_verification) }
  it { should respond_to(:card_expires_on) }
  it { should respond_to(:credit_card) }
  it { should respond_to(:ip_address) }
  it { should respond_to(:email) }

end