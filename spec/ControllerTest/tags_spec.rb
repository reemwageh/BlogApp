require 'rails_helper'

RSpec.describe "Tags API", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization': token_generator(user.id) } }

  describe "GET /tags" do
    it "returns all tags" do
      create_list(:tag, 5)
      get "/tags"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  describe "POST /tags" do
    it "creates a tag" do
      post "/tags", params: { name: "Tech" }, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Tech")
    end
  end
end
