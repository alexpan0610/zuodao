class CartsController < ApplicationController
  before_action :aunthenticate_user!, only: [:do_checkout]

  def index
    @cart_items = current_cart.get_items
  end

  def checkout
    case params[:submit]
    when "delete_selected_items"
      unless params[:selections].present?
        flash[:warning] = "请至少选中一件商品"
        redirect_to carts_path
      else
        params[:selections].each do |selection|
          CartItem.find(selection).destroy
        end
        flash[:alert] = "已删除选中的商品"
        redirect_to carts_path
      end
    when "checkout"
      unless params[:selections].present?
        flash[:warning] = "请至少选中一件商品"
        redirect_to carts_path
      else
        @cart_items = []
        params[:selections].each do |selection|
          @cart_items << CartItem.find(selection)
        end
        @order = Order.new
        @receiving_infos = current_user.receiving_infos
      end
    end
  end
end
