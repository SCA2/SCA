require 'spec_helper'

describe Address do
	it "is valid with a first_name, last_name, address_1, city, state_code and country" do
		address = Address.new(
			first_name: 'Joe',
			last_name: 'Blow',
			address_1: '123 Main Street',
			city: 'Topeka',
			state_code: 'KS',
			country: 'US')
		expect(address).to be_valid
	end

	it "is invalid without a first_name" do
		expect(Address.new(first_name: nil)).to have(1).errors_on(:first_name)
	end

	it "is invalid without a last_name" do
		expect(Address.new(last_name: nil)).to have(1).errors_on(:last_name)
	end

	it "is invalid without an address" do
		expect(Address.new(address_1: nil)).to have(1).errors_on(:address_1)
	end

	it "is invalid without a city" do
		expect(Address.new(city: nil)).to have(1).errors_on(:city)
	end

	it "is invalid without a state" do
		expect(Address.new(state_code: nil)).to have(1).errors_on(:state_code)
	end

	it "does not allow duplicate addresses per user" do
		user = User.create(name: 'Joe', email: 'joetester@example.com', password: 'password')
		address_1 = user.addresses.create(
			first_name: 'Joe',
			last_name: 'Blow',
			address_1: '123 Main Street',
			city: 'Topeka',
			state_code: 'KS',
			country: 'US',
			addressable_id: 1,
			addressable_type: 'home')
		address_2 = user.addresses.create(
			first_name: 'Joe',
			last_name: 'Blow',
			address_1: '123 Main Street',
			city: 'Topeka',
			state_code: 'KS',
			country: 'US',
			addressable_id: 1,
			addressable_type: 'home')
		expect(address_2).to have(6).errors
	end

	it "allows two users to share an address" do
		user_1 = User.create(name: 'Test_1', email: 'tester1@example.com', password: 'password')
		user_2 = User.create(name: 'Test_2', email: 'tester2@example.com', password: 'password')
		address = Address.create(
			first_name: 'Joe',
			last_name: 'Blow',
			address_1: '123 Main Street',
			city: 'Topeka',
			state_code: 'KS',
			country: 'US',
			addressable_id: 1,
			addressable_type: 'home')
		user_1.addresses << address
		user_2.addresses << address
		expect(user_1.addresses).to have(0).errors
	end

end
