class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:login, :signup]

  def signup
    user = User.new(user_params)

    if user.save
      render json: { message: 'User created successfully. Please log in to continue.' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :image)
  end
end