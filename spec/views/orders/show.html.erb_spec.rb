require 'rails_helper'

describe "orders/show" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :cart_id => 1,
      :first_name => "First Name",
      :last_name => "Last Name",
      :shipping_address_1 => "Shipping Address 1",
      :shipping_address_2 => "Shipping Address 2",
      :shipping_city => "Shipping City",
      :shipping_state => "Shipping State",
      :shipping_post_code => "Shipping Post Code",
      :shipping_country => "Shipping Country",
      :email => "Email",
      :telephone => "Telephone",
      :card_type => "Card Type",
      :cart_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Shipping Address 1/)
    rendered.should match(/Shipping Address 2/)
    rendered.should match(/Shipping City/)
    rendered.should match(/Shipping State/)
    rendered.should match(/Shipping Post Code/)
    rendered.should match(/Shipping Country/)
    rendered.should match(/Email/)
    rendered.should match(/Telephone/)
    rendered.should match(/Card Type/)
    rendered.should match(/2/)
  end
end
