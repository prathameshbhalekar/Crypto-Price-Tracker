require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "PUT /auth/signup" do
    it "creates new user" do
      username = "test_user"
      password = "test@123"
      email = "test@test.com"
      
      post "/auth/signup", params: {
          username: username,
          password: password,
          email: email
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
      expect(response.body).to include("Created User")
      expect(User.where(username: username).count).to eq 1

    end

    it "doesn't create duplicate user" do
      username = "test_user"
      email = "test@test.com"
      password = "test@123"

      User.create(
        username: username,
        email: email,
        password: password
      )

      post "/auth/signup", params: {
          username: username,
          email: email,
          password: password
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Username has already been taken")
      expect(User.where(username: username).count).to eq 1

    end

    it "doesn't create new user for invalid password" do
      username = "test_user"
      email = "test@test.com"
      password = "test_password"

      post "/auth/signup", params: {
          username: username,
          email: email,
          password: password
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Password is invalid")
      expect(User.where(username: username).count).to eq 0

      post "/auth/signup", params: {
          username: username,
          email: email,
          password: "short"
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Password is invalid")
      expect(User.where(username: username).count).to eq 0

    end

    it "doesn't create new user for invalid email" do
      username = "test_user"
      password = "test_password123"

      post "/auth/signup", params: {
          username: username,
          password: password
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Email can't be blank")
      expect(User.where(username: username).count).to eq 0

      post "/auth/signup", params: {
          username: username,
          email: "invalid_email.com",
          password: password
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Email is invalid")
      expect(User.where(username: username).count).to eq 0
    end
  end

  describe "PUT /auth/login" do
    it "logs in only for right password and username" do
      username = "test_user"
      email = "test@test.com"
      password = "test@123"
      
      User.create(
        username: username,
        email: email,
        password: password
      )

      post "/auth/login", params: {
          username: username,
          password: password
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Logged in Successfully")
      expect(response.body).to include("token")
  
      post "/auth/login", params: {
          username: username,
          password: "wrong_password"
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("Username and password don't match")
      expect(response.body).to_not include("token")
  
      post "/auth/login", params: {
          username: "wrong_username",
          password: "wrong_password"
      }
      
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("Username and password don't match")
      expect(response.body).to_not include("token")
  
    end
  end  
end
