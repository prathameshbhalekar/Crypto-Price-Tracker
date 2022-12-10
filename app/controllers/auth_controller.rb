class AuthController < ApplicationController
  def signup
    @user = User.new(
      username: params[:username], 
      email: params[:email], 
      password: params[:password]
    )

    if @user.save
      render json: {msg: "Created User", data: @user}, status: :created
    else
      render json: { err: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      token = encode_jwt(username: @user.username)
      time = Time.now + 24.hours.to_i
      render json: {
        msg: "Logged in Successfully", 
        data: { 
          token: token, 
          exp: time.strftime("%m-%d-%Y %H:%M"),
          username: @user.username 
          }
        }, status: :ok
    else
      render json: { err: "Username and password don't match" }, status: :unauthorized
    end
  end
end
