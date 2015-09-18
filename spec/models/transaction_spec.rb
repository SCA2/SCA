require 'rails_helper'

describe Transaction do
  
  let(:transaction) { create(:transaction) }

  it { should respond_to(:response=) }

end
