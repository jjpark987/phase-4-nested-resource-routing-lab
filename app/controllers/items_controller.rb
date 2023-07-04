class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_message
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_message

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else 
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  # def create
  #   user = User.find(params[:user_id])
  #   item = Item.create!(item_params)
  #   render json: item, include: :user, status: :created
  # end
  def create
    user = User.find(params[:user_id])
    if user
      item = Item.create!(item_params.merge(user: user))
      render json: item, include: :user, status: :created
    end
  end
  

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_message e
    render json: { error: e }, status: :not_found
  end

  def render_invalid_message e 
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
