class PostsController < ApplicationController
  def index
    @posts = Post.all
    render json: @posts, status: :ok
  end

  def show
    @post = Post.includes(:comments, :tags).find_by(id: params[:id])

    if @post
      render json: @post.as_json(
        include: {
          comments: { include: :user },
          tags: {}
        }
      ), status: :ok
    else
      render json: { error: "Post not found" }, status: :not_found
    end
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @post = current_user.posts.find_by(id: params[:id])
    if @post && @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { error: "Not authorized or invalid post" }, status: :forbidden
    end
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    if @post&.destroy
      head :no_content # 204 No Content
    else
      render json: { error: "Not authorized or post not found" }, status: :forbidden
    end
  end

  private

  def post_params
    params.permit(:title, :body, tag_ids: [])
  end
end