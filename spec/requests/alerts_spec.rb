require 'rails_helper'
require './spec/utils'

RSpec.describe "alerts", type: :request do

  describe "POST alerts/create" do
    
    before do
      @username = "test_user"
      @password = "password123"
      @email = "test@test.com"
      @user = User.create(username: @username, email: @email, password: @password)
    end

    it "creates new alerts" do

      token = authenticate @username, @password
      stub_get_price_req

      post "/alerts/create", params: {
          symbol: "bitcoin",
          trigger: 10
      },
      headers: {
        Authorization: "Bearer #{token}"
      }


      body = JSON.parse(response.body)
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
      expect(response.body).to include("Created Alert")
      expect(body["data"]["init_price"]).to eq 1
      expect(Alert.where(user: @user, id: body["data"]["id"]).count).to eq 1
    end

    it "requires authentication" do
      post "/alerts/create", params: {
          symbol: "bitcoin",
          trigger: 10
      },
      headers: {
        Authorization: "Bearer random_token"
      }
       
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
    end

    it "does not create alert for invalid symbol" do
      stub_authentication(@username)
      stub_get_price_req("random_symbol", "[]")

      post "/alerts/create", params: {
          symbol: "random_symbol",
          trigger: 10
      },
      headers: {
        Authorization: "Bearer random_token"
      }
 
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Symbol not found")
    end
  end

  describe "GET alerts/allAlerts" do
    before do
      @username = "test_user"
      @password = "password123"
      @email = "test@test.com"
      @user = User.create(username: @username, email: @email, password: @password)

      Alert.create(
        trigger: 1, 
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

    it "fetches all alerts" do

      token = authenticate @username, @password

      get "/alerts/allAlerts",
      headers: {
        Authorization: "Bearer #{token}"
      }

      body = JSON.parse(response.body)
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Success")
      expect(body["data"].length).to eq @user.getAllAlerts("all", "all").count
    end

    it "requires authentication" do
      get "/alerts/allAlerts",
      headers: {
        Authorization: "Bearer random_token"
      }
       
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
    end

    it "filters by symbol" do
      stub_authentication(@username)

      get "/alerts/allAlerts",
      params:{
        symbol: "symbol1"
      },
      headers: {
        Authorization: "Bearer random_token"
      }

      body = JSON.parse(response.body)
      
      body["data"].each { |alert| expect(alert['symbol']).to eq("symbol1") }

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Success")
      expect(body["data"].length).to eq @user.getAllAlerts("all", "symbol1").count
    end

    it "filters by status" do
      stub_authentication(@username)

      get "/alerts/allAlerts",
      params:{
        is_active: "false"
      },
      headers: {
        Authorization: "Bearer random_token"
      }

      body = JSON.parse(response.body)

      body["data"].each { |alert| expect(alert['is_active']).to eq(false) }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Success")
      expect(body["data"].length).to eq @user.getAllAlerts("false", "all").count
    end
  end

  describe "DELETE /alerts/deleteAlert" do 
    before do
      @username = "test_user"
      @password = "test@123"
      @email = "test@test.com"

      @user = User.create(username: @username, email: @email, password: @password)
    end

    it "deletes alerts" do
      alert = Alert.create(
        trigger: 1, 
        is_active: true,
        symbol: "symbol1",
        user: @user,
        init_price: 1
      )

      token = authenticate @username, @password
      

      delete "/alerts/deleteAlert", params: {
        id: alert.id
      },
      headers: {
        Authorization: "Bearer #{token}"
      } 


      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Deleted Successfully")
      expect(Alert.where(user: @user, id: alert.id).count).to eq 0

    end

    it "requires authentication" do
      delete "/alerts/deleteAlert", params: {
        id: 123
      },
      headers: {
        Authorization: "Bearer random_token"
      }
       
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
    end

    it "throws error when id not found" do
      stub_authentication @username
      

      delete "/alerts/deleteAlert", params: {
        id: 1224 # random id
      },
      headers: {
        Authorization: "Bearer random_token"
      } 


      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Alert with Id not found")

    end
  end

  
end
