class Account::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product_by_id, only: [:favorite, :dislikes]
  respond_to :js, only: [:favorite, :dislikes]

  def index
    @products = current_user.favorited_courses
  end

  def favorite
    if !current_user.favorited?(@product)
      current_user.favorite!(@product)
      flash.now[:notice] = "课程#{@product.title}已加入收藏~"
    else
      flash.now[:warning] = "您已经收藏过课程#{@product.title}~"
    end
  end

  def dislikes
    if current_user.favorited?(@product)
      current_user.dislikes!(@product)
      flash.now[:notice] = "已经取消收藏课程#{@product.title}~"
    else
      flash.now[:warning] = "您没有收藏过课程#{@product.title}~"
    end
  end

  private

  def find_product_by_id
    @product = Product.find(params[:id])
  end
end
