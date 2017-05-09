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
    # 如果已在购物车中，增加数量，否则加入购物车
    if current_cart.products.include?(@product)
      current_cart.increase_product_quantity(@product, @quantity)
    else
      current_cart.add_product_to_cart(@product, @quantity)
    end
    respond_to do |format|
      format.js   { render layout: false }
    end
  end

  private

  def validate_search_key
    @query = params[:query].gsub(/\|\'|\/|\?/, "") if params[:query].present?
  end
end
