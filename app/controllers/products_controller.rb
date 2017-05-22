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
    case params[:commit]
    when "add_to_cart"
      # 加入购物车
      add_to_cart(is_over_sell?)
    when "order_now"
      # 立即下单
      order_now(is_over_sell?)
    end
  end

  private

  # 加入购物车
  def add_to_cart(over_sell)
    current_cart.add(@product, @quantity)
    if over_sell
      flash[:warning] = "您选择的数量超过课程名额，实际提交的名额为#{@quantity}人。"
      redirect_to product_path(@product)
    else
      respond_to do |format|
        format.js { render "products/add_to_cart"}
      end
    end
  end

  # 立即下单
  def order_now(over_sell)
    item = current_cart.add(@product, @quantity)
    if over_sell
      if @quantity > 0
        flash[:warning] = "您选择的数量超过课程名额，实际提交的名额为#{@quantity}人。"
      else
        flash[:warning] = "您报名的课程#{@product.title}名额已满！"
        return redirect_to product_path(@product)
      end
    end
    redirect_to checkout_cart_path(item_ids:[item.id])
  end

  # 是否超卖
  def is_over_sell?
    @product = Product.find(params[:id])
    @quantity = params[:quantity].to_i
    if @quantity > @product.quantity
      @quantity = @product.quantity
      true
    else
      false
    end
  end

  def validate_search_key
    @query = params[:query].gsub(/\|\'|\/|\?/, "") if params[:query].present?
  end
end
