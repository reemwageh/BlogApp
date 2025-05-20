class ApplicationController < ActionController::API
  attr_reader :current_user
  before_action :authorize_request
  def authorize_request
    puts "\n--- AUTH START ---"
    puts "Raw Auth Header: #{request.headers['Authorization'].inspect}"

    token = request.headers['Authorization']&.split(' ')&.last
    puts "Extracted Token: #{token.inspect}"

    return render json: { error: 'Missing token' }, status: :unauthorized unless token

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
      puts "Decoded: #{decoded.inspect}"

      user_id = decoded[:user_id] || decoded['user_id']
      puts "Looking for user with ID: #{user_id}"

      @current_user = User.find(user_id)
      puts "Found user: #{@current_user.name}"
    rescue JWT::DecodeError => e
      puts "JWT Error: #{e.message}"
      render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      puts "User not found for ID: #{user_id}"
      render json: { error: "User not found" }, status: :unauthorized
    end
  end
end