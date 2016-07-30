require 'rails_helper'

describe TermsValidator do

  it { should respond_to(:accept_terms) }

  it 'is valid with valid params' do
    params = { accept_terms: '1'}
    expect(TermsValidator.new(params)).to be_valid
  end

  it 'is not valid with invalid params' do
    params = { accept_terms: '0'}
    expect(TermsValidator.new(params)).to_not be_valid
  end

end