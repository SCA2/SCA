require 'rails_helper'

describe Transaction do
  before do
    @transaction = build(:transaction)
  end
  
  subject { @transaction }

  it { should respond_to(:response=) }

end
