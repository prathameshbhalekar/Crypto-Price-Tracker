require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "is valid with valid attributes" do
    expect(User.new(
      username: "test_user",
      email: "test@test.com", 
      password: "test_password@123"
    )).to be_valid
  end

  it "is not valid without a username" do
    expect(User.new(
      email: "test@test.com",
      password: "test_password@123"
    )).to_not be_valid
  end

  it "is not valid with duplicate username" do
    expect(User.create(
      username: "test_user", 
      email: "test@test.com",
      password: "test_password@123"
    )).to be_valid
    
    expect(User.new(
      username: "test_user", 
      email: "test@test.com",
      password: "test_password@123"
    )).to_not be_valid
  end

  it "is not valid without a password" do
    expect(User.new(username: "test_username", email: "test@test.com")).to_not be_valid
  end

  it "is not valid with password less than 6 characters" do
    expect(User.new(
      username: "test_user", 
      email: "test@test.com",
      password: "pass"
    )).to_not be_valid
  end

  it "is not valid with password without number" do
    expect(User.new(
      username: "test_user",
      email: "test@test.com", 
      password: "test_password@"
    )).to_not be_valid
  end

  it "is not valid without email" do
    expect(User.new(
      username: "test_user",
      password: "test_password@123"
    )).to_not be_valid
  end

  it "is not valid without correct email format" do
    expect(User.new(
      username: "test_user",
      email: "wrong_email.com",
      password: "test_password@123"
    )).to_not be_valid
  end

  context "fetch alerts" do 
    before do
      @user = User.create(
        username: "test_user", 
        email: "test@test.com",
        password: "test_password@123"
      )

      Alert.create(
        trigger: 10.0, 
        is_active: true,
        symbol: "symbol1",
        user: @user,
        init_price: 1
      )
  
      Alert.create(
        trigger: 1, 
        is_active: false,
        symbol: "symbol2",
        user: @user,
        init_price: 1
      )
    end

    it "returns all alerts" do
      expect(@user.getAllAlerts("all", "all").count).to eq 2
    end
  
    
    it "returns all alerts filtered by symbol" do
      expect(@user.getAllAlerts("all", "symbol1").count).to eq 1
      expect(@user.getAllAlerts("all", "symbol2").count).to eq 1
  
    end
  
    it "returns all alerts filtered by 'is_active'" do
      expect(@user.getAllAlerts("true", "all").count).to eq 1
      expect(@user.getAllAlerts("false", "all").count).to eq 1
  
    end
  end

  

end
