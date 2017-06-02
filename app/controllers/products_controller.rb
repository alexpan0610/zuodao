class ProductsController < ApplicationController
  before_action :validate_search_key, only: [:index]

  def index
    @result = Product.ransack(search_criteria).result(distinct: true).includes("category")
    if params[:category].blank?
      @products = @result.order('created_at DESC')
    else
      @products = @result.where(category_id: params[:category].to_i)
    end
    @products = @products.page(params[:page]).per_page(9)
  end

  def show
    @product = Product.find(params[:id])
  end

  # 对商品的操作，包括加入购物车和立即下单
  def operations
    @product = Product.find(params[:id])
    @quantity = params[:quantity].to_i
    # 判断操作类型
    case params[:commit]
    when "add_to_cart"
      # 加入购物车
      if current_cart.add!(@product, @quantity)
        flash.now[:notice] = "课程 #{@product.title} 的 #{@quantity} 个名额已加入购物车！"
      else
        flash.now[:warning] = "您加入购物车的数量超出课程 #{@product.title} 的名额！"
      end
      respond_to do |format|
        format.js { render "products/add_to_cart" }
      end
    when "order_now"
      # 立即下单
      if @quantity > @product.quantity
        return redirect_to product_path(@product), warning: "您下单的数量超出课程 #{@product.title} 的名额！"
      end
      item = CartItem.new(product: @product, quantity: @quantity)
      if item.save
        redirect_to checkout_cart_path(item_ids:[item.id])
      else
        redirect_to product_path(@product), warning: "课程#{@product.title}下单失败!~"
      end
    end
  end

  private

  def validate_search_key
    @query = params[:query].gsub(/\|\'|\/|\?/, "") if params[:query].present?
  end

  # 配置搜索的字段
  def search_criteria
    {
      category_name_cont: @query, # 课程类型
      title_cont: @query, # 课程名称
      description_cont: @query, # 课程描述
      catalog_cont: @query, # 课程目录
      m: 'or'
    }
  end
end
