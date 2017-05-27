class ProductsController < ApplicationController
  before_action :validate_search_key, only: [:index]

  def index
    @result = Product.ransack(
    category_name_cont: @query,
    title_cont: @query,
    description_cont: @query,
    m: 'or'
    ).result(distinct: true).includes("category")
    if params[:category].blank?
      @products = @result.order('created_at DESC')
    else
      @products = @result.where(category_id: params[:category].to_i)
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def operations
    @product = Product.find(params[:id])
    @quantity = params[:quantity].to_i
    case params[:commit]
    when "add_to_cart"
      # 加入购物车
      current_cart.add!(@product, @quantity)
      flash.now[:notice] = "课程 #{@product.title} 的 #{@quantity} 个名额已加入购物车！"
      respond_to do |format|
        format.js { render "products/add_to_cart" }
      end
    when "order_now"
      # 立即下单
      item = current_cart.add!(@product, @quantity)
      redirect_to checkout_cart_path(item_ids:[item.id])
    end
  end

  private

  def validate_search_key
    @query = params[:query].gsub(/\|\'|\/|\?/, "") if params[:query].present?
  end
end
