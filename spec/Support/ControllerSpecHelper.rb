# frozen_string_literal: true

module ControllerSpecHelper
  # Generate a token from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end
end
