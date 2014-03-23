json.array!(@orders) do |order|
  json.extract! order, :id, :cart_id, :first_name, :last_name, :shipping_address_1, :shipping_address_2, :shipping_city, :shipping_state, :shipping_post_code, :shipping_country, :email, :telephone, :card_type, :card_expires_on, :cart_id
  json.url order_url(order, format: :json)
end
