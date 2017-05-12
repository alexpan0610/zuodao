class CartsController < ApplicationController
  before_action :aunthenticate_user!, only: [:do_checkout]

  def index
    @cart_items = current_cart.get_items
    @selections = []
  end

  def operations
    if params[:delete_item].present?
      delete_item
    elsif params[:delete_items].present?
      delete_items
    elsif params[:checkout].present?
      do_checkout
    end
  end

  def checkout
    @cart_items = []
    params[:selections].each do |selection|
      @cart_items << CartItem.find(selection)
    end
    @order = Order.new
    @receiving_infos = current_user.receiving_infos
  end

  private

  def delete_item
    @selections = params[:selections].present? ? params[:selections].to_a : []
    @cart_item = CartItem.find(params[:delete_item])
    change_quantity(-@cart_item.quantity)
    @cart_item.destroy
    @selections.delete(params[:delete_item])
    respond_to do |format|
      format.js { render "carts/delete_item"}
    end
  end

  def delete_items
    unless params[:selections].present?
      flash[:warning] = "请至少选中一件商品"
    else
      params[:selections].each do |selection|
        CartItem.find(selection).destroy
      end
      flash[:alert] = "已删除选中的商品"
    end
    redirect_to carts_path
  end

  def do_checkout
    unless params[:selections].present?
      flash[:warning] = "请至少选中一件商品"
      redirect_to carts_path
    else
      redirect_to checkout_cart_path(selections: params[:selections])
    end
  end
end
