require 'rails_helper'

describe "features/index" do
  before(:each) do
    assign(:features, [
      stub_model(Feature),
      stub_model(Feature)
    ])
  end

  it "renders a list of features" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
