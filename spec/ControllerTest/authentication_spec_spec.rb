require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  # Signup Tests
  describe "POST /signup" do
    it "creates a user with valid data" do
      post "/signup", params: {
        name: "Reem Wageh",
        email: "reem@example.com",
        password: "password123"
      }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["message"]).to eq("User created successfully. Please log in to continue.")
    end

    it "fails when name is missing" do
      post "/signup", params: {
        name: "",
        email: "reem@example.com",
        password: "password123"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails when email is already taken" do
      # First signup
      User.create!(name: "Reem", email: "reem@example.com", password: "password123")

      # Try to signup again
      post "/signup", params: {
        name: "Reem",
        email: "reem@example.com",
        password: "password123"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  # Login Tests
  describe "POST /login" do
    before do
      @user = User.create!(name: "Reem", email: "reem@example.com", password: "password123")
    end

    it "logs in with correct email and password" do
      post "/login", params: {
        email: "reem@example.com",
        password: "password123"
      }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key("token")
    end

    it "fails with incorrect password" do
      post "/login", params: {
        email: "reem@example.com",
        password: "wrongpassword"
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it "fails with unregistered email" do
      post "/login", params: {
        email: "notfound@example.com",
        password: "password123"
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it "fails with missing email" do
      post "/login", params: {
        email: "",
        password: "password123"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
