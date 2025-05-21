class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:login, :signup]
  include Rails.application.routes.url_helpers

  def signup
  user = User.new(user_params)

  if user.save
    image_url = url_for(user.image) if user.image.attached?
    render json: {
      message: 'User created successfully. Please log in to continue.',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        image_url: image_url
      }
    }, status: :created
  else
    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  end
end

  def login
    if params[:email].blank? || params[:password].blank?
      return render json: { error: 'Email and password are required' }, status: :unprocessable_entity
    end
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