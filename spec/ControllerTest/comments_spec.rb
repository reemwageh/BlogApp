require 'rails_helper'

RSpec.describe "Comments API", type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user: user) }
  let(:headers) { { 'Authorization': token_generator(user.id) } }

  describe "POST /comments" do
    it "creates a comment" do
      post "/comments", params: { body: "Nice post!", post_id: post_record.id }, headers: headers
      expect(response).to have_http_status(:created)
    end
  end

  describe "DELETE /comments/:id" do
    let(:comment) { create(:comment, user: user, post: post_record) }

    it "deletes the comment" do
      delete "/comments/#{comment.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
