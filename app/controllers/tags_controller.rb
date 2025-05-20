class TagsController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]

  def index
    @tags = Tag.all
    render json: @tags, status: :ok
  end

  def show
    @tag = Tag.find_by(id: params[:id])
    if @tag
      render json: @tag, status: :ok
    else
      render json: { error: "Tag not found" }, status: :not_found
    end
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag, status: :created
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @tag = Tag.find_by(id: params[:id])
    if @tag && @tag.update(tag_params)
      render json: @tag, status: :ok
    else
      render json: { error: "Tag not found or invalid data" }, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find_by(id: params[:id])
    if @tag&.destroy
      head :no_content
    else
      render json: { error: "Tag not found or already deleted" }, status: :not_found
    end
  end

  private

  def tag_params
    params.permit(:name)
  end
end