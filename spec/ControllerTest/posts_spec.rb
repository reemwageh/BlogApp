require 'rails_helper'

RSpec.describe "Posts API", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization': token_generator(user.id) } }

  describe "GET /posts" do
    it "returns all posts" do
      create_list(:post, 3, user: user)
      get "/posts", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /posts" do
    let!(:tag) { create(:tag) } # Create a tag beforehand

    let(:valid_params) do
      {
        title: "New Post",
        body: "Post Body",
        tag_ids: [tag.id] # Include one tag
      }
    end

    it "creates a new post" do
      post "/posts", params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["title"]).to eq("New Post")
    end
  end
  end
