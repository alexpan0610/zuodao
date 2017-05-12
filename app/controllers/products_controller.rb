class ProductsController < ApplicationController
  before_action :validate_search_key, only: [:index]

  def index
    @result = Product.ransack(
    title_cont: @query,
    description_cont: @query,
    m: 'or'
    ).result(distinct: true)
    if params[:category].blank?
      @products = @result.order('created_at DESC')
    else
      @products = @result.where(category_id: params[:category].to_i)
    end
    # 显示方式，列表或网格
    params[:view] = params[:view].present? ? params[:view] : 'grid'
  end

  def show
    @product = Product.find(params[:id])
  end

  def add_to_cart
    @product = Product.find(params[:id])
    @quantity = params[:quantity].present? ? params[:quantity].to_i : 1
    # 验证加入购物车的商品数量是否超过库存
    if @quantity > @product.quantity
      @quantity = @product.quantity
      current_cart.add(@product, @quantity)
      flash[:warning] = "您加入购物车的商品数量超过库存，实际加入购物车的商品数量为#{@quantity}件。"
      redirect_to product_path(@product)
    else
      current_cart.add(@product, @quantity)
      respond_to :js
    end
  end

  private

  def validate_search_key
    @query = params[:query].gsub(/\|\'|\/|\?/, "") if params[:query].present?
  end
end
