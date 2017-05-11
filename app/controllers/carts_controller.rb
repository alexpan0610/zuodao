class CartsController < ApplicationController
  before_action :aunthenticate_user!, only: [:do_checkout]

  def index
    @cart_items = current_cart.get_items
  end

  def checkout
    if params[:delete_selected_items].present?
      params[:selections].each do |selection|
        CartItem.find(selection).destroy
      end
      flash[:alert] = "已删除选中的商品"
      redirect_to carts_path
    elsif params[:checkout].present?
      @cart_items = []
      unless params[:selections].present?
        flash[:warning] = "请至少选中一件商品"
        redirect_to carts_path
      else
        params[:selections].each do |selection|
          @cart_items << CartItem.find(selection)
        end
        @order = Order.new
      end
    end
  end
end
