class ApplicationController < ActionController::API
  SECRET_KEY = ENV['JWT_SECRET']

  def encode_jwt(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_jwt(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    
    begin
      @decoded = decode_jwt(token)
      @current_user = User.find_by(username: @decoded[:username])
      
      if @current_user.nil?
        return render json: { errors: "User not found" }, status: :unauthorized
      end
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
