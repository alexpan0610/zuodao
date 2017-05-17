class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]

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
    @items = []
    params[:selections].each do |selection|
      item = CartItem.find(selection)
      # 验证订单课程数量是否超过名额
      if item.quantity > item.product.quantity
        item.quantity = item.product.quantity
        item.save
        flash[:warning] = "您下单的课程#{product.title}超出名额，实际提交的名额为#{item.quantity}人。"
      end
      @items << item
    end
    @order = Order.new
    @addresses = current_user.addresses
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
      flash[:warning] = "请至少选中一门课程"
    else
      params[:selections].each do |selection|
        CartItem.find(selection).destroy
      end
      flash[:alert] = "已删除选中的课程"
    end
    redirect_to carts_path
  end

  def do_checkout
    unless params[:selections].present?
      flash[:warning] = "请至少选中一门课程"
      redirect_to carts_path
    else
      redirect_to checkout_cart_path(selections: params[:selections])
    end
  end
end
