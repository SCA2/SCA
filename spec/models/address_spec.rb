require 'rails_helper'

describe Address do
	it "has a valid factory" do
		expect(create(:address)).to be_valid
	end

	it "is invalid without a first_name" do
		address = build(:address, first_name: nil)
		expect(address).not_to be_valid
	end

	it "is invalid without a last_name" do
		address = build(:address, last_name: nil)
		expect(address).not_to be_valid
	end

	it "is invalid without an address" do
		address = build(:address, address_1: nil)
		expect(address).not_to be_valid
	end

	it "is invalid without a city" do
		address = build(:address, city: nil)
		expect(address).not_to be_valid
	end

	it "is invalid without a state" do
		address = build(:address, state_code: nil)
		expect(address).not_to be_valid
	end

	it "does not allow duplicate addresses per user" do
		user = create(:user)
		address = attributes_for(:address)
		address_1 = user.addresses.create(address)
		address_2 = user.addresses.create(address)
		expect(address_1).to have(0).errors
		expect(address_2).to have(6).errors
	end

	it "allows two users to share an address" do
		user_1 = create(:user)
		user_2 = create(:user)
		address = attributes_for(:address)
		user_1.addresses.create(address)
		user_2.addresses.create(address)
		expect(user_1.addresses.last).to have_attributes(address)
		expect(user_2.addresses.last).to have_attributes(address)
	end

end
