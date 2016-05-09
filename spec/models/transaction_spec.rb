require 'rails_helper'

describe Transaction do
  
  let(:transaction) { create(:transaction) }

  it { should respond_to(:response=) }
  it { should respond_to(:action) }
  it { should respond_to(:amount) }
  it { should respond_to(:success) }
  it { should respond_to(:authorization) }
  it { should respond_to(:message) }
  it { should respond_to(:params) }

  describe 'associations' do
    it 'belongs to one order' do
    end
  end
end
