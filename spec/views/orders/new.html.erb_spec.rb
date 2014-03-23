require 'spec_helper'

describe "orders/new" do
  before(:each) do
    assign(:order, stub_model(Order,
      :cart_id => 1,
      :first_name => "MyString",
      :last_name => "MyString",
      :shipping_address_1 => "MyString",
      :shipping_address_2 => "MyString",
      :shipping_city => "MyString",
      :shipping_state => "MyString",
      :shipping_post_code => "MyString",
      :shipping_country => "MyString",
      :email => "MyString",
      :telephone => "MyString",
      :card_type => "MyString",
      :cart_id => 1
    ).as_new_record)
  end

  it "renders new order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", orders_path, "post" do
      assert_select "input#order_cart_id[name=?]", "order[cart_id]"
      assert_select "input#order_first_name[name=?]", "order[first_name]"
      assert_select "input#order_last_name[name=?]", "order[last_name]"
      assert_select "input#order_shipping_address_1[name=?]", "order[shipping_address_1]"
      assert_select "input#order_shipping_address_2[name=?]", "order[shipping_address_2]"
      assert_select "input#order_shipping_city[name=?]", "order[shipping_city]"
      assert_select "input#order_shipping_state[name=?]", "order[shipping_state]"
      assert_select "input#order_shipping_post_code[name=?]", "order[shipping_post_code]"
      assert_select "input#order_shipping_country[name=?]", "order[shipping_country]"
      assert_select "input#order_email[name=?]", "order[email]"
      assert_select "input#order_telephone[name=?]", "order[telephone]"
      assert_select "input#order_card_type[name=?]", "order[card_type]"
      assert_select "input#order_cart_id[name=?]", "order[cart_id]"
    end
  end
end
