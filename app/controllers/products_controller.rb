class ProductsController < ApplicationController
  before_action :validate_search_key, only: [:search]
  before_action :get_products, only: [:index, :show]

  def index
    @products = Product.ransack(
    title_cont: @query_string,
    description_cont: @query_string,
    m: 'or'
    ).result(distinct: true)
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
    @query_string = params[:query_string].gsub(/\|\'|\/|\?/, "") if params[:query_string].present?
  end
end
