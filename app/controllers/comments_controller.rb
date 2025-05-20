class CommentsController < ApplicationController
  before_action :authorize_request

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @comment = current_user.comments.find_by(id: params[:id])
    if @comment&.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: { error: "Not authorized or invalid comment" }, status: :forbidden
    end
  end

  def destroy
    @comment = current_user.comments.find_by(id: params[:id])
    if @comment&.destroy
      head :no_content
    else
      render json: { error: "Not authorized or comment not found" }, status: :not_found
    end
  end

  private

  def comment_params
    params.permit(:body, :post_id)
  end
end