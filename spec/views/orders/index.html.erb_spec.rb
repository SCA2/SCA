require 'spec_helper'

describe "orders/index" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
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
      ),
      stub_model(Order,
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
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Shipping Address 1".to_s, :count => 2
    assert_select "tr>td", :text => "Shipping Address 2".to_s, :count => 2
    assert_select "tr>td", :text => "Shipping City".to_s, :count => 2
    assert_select "tr>td", :text => "Shipping State".to_s, :count => 2
    assert_select "tr>td", :text => "Shipping Post Code".to_s, :count => 2
    assert_select "tr>td", :text => "Shipping Country".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Telephone".to_s, :count => 2
    assert_select "tr>td", :text => "Card Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
