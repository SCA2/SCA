require 'rails_helper'

describe "features/edit" do
  before(:each) do
    @feature = assign(:feature, stub_model(Feature))
  end

  it "renders the edit feature form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", feature_path(@feature), "post" do
    end
  end
end
