# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

	# has_one :order, inverse_of: :cart
	# has_many :line_items, dependent: :destroy, inverse_of: :cart
	# accepts_nested_attributes_for :line_items, allow_destroy: true

  factory :cart do
    purchased_at { Time.now }
    # created_at { Time.now }
    # updated_at { Time.now }
    order
    line_item
  end
end
