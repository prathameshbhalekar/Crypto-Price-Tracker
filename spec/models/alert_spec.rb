require 'rails_helper'
require './spec/utils'

RSpec.describe Alert, type: :model do
	before do
		@user = User.create(
			username: "test_user", 
			email: "test@test.com",
			password: "test_password@123"
		)
	end

    it "is valid with valid attributes" do

		stub_get_price_req
		
		
		
		alert = Alert.new(
			trigger: 1, 
			is_active: true,
			symbol: "bitcoin",
			user: @user
		)

		expect(alert).to be_valid
	end

    it "is not valid without a trigger" do
		
		stub_get_price_req

		alert = Alert.new(
			is_active: true,
			symbol: "bitcoin",
			user: @user
		)

		expect(alert).to_not be_valid
	end

	it "is not valid without a symbol" do
		stub_get_price_req("")
		
		alert = Alert.new(
			is_active: true,
			trigger: 10,
			user: @user
		)

		expect(alert).to_not be_valid
	end

	it "is not valid with a invalid symbol" do
		stub_get_price_req("random_symbol", "[]")

		alert = Alert.new(
			is_active: true,
			trigger: 10,
			user: @user,
			symbol: "random_symbol"
		)

		expect(alert).to_not be_valid
	end

	it "initializes 'init_price'" do
		stub_get_price_req

		alert = Alert.new(
			is_active: true,
			trigger: 10,
			user: @user,
			symbol: "bitcoin"
		)

		expect(alert).to be_valid
		expect(alert.init_price).to eq 1
	end

    
end

