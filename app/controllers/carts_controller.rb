class CartsController < ApplicationController
  before_action :authenticate_user!, only: :checkout
  before_action :save_back_url, only: :checkout

  def index
    @cart_items = current_cart.get_items
    @item_ids = []
  end

  # 用户对购物车的操作都经过这里
  def operations
    if params[:delete_item].present? # 用户删除单个课程
      delete_item
    elsif params[:delete_items].present? # 用户删除多个课程
      delete_items
    elsif params[:checkout].present? # 用户进行结算
      do_checkout
    end
  end

  # 结算页
  def checkout
    # 获取购物清单
    @items = CartItem.where(id: params[:item_ids])
    @order = Order.new
    # 获取用户的地址列表
    @addresses = current_user.addresses
  end

  private

  # 删除单个课程
  def delete_item
    @item_ids = params[:item_ids].present? ? params[:item_ids].to_a : []
    @cart_item = CartItem.find(params[:delete_item])
    @cart_item.destroy
    @item_ids.delete(params[:delete_item])
    flash.now[:notice] = "课程 #{@cart_item.product.title} 已从购物车中移除~"
    respond_to do |format|
      format.js { render "carts/delete_item"}
    end
  end

  # 删除多个课程
  def delete_items
    unless params[:item_ids].present?
      flash[:warning] = "请至少选中一门课程"
    else
      CartItem.where(id: params[:item_ids]).destroy_all
      flash[:alert] = "已删除选中的 #{params[:item_ids].size} 门课程"
    end
    redirect_to carts_path
  end

  # 进行结算
  def do_checkout
    unless params[:item_ids].present?
      flash[:warning] = "请至少选中一门课程"
      redirect_to carts_path
    else
      redirect_to checkout_cart_path(item_ids: params[:item_ids])
    end
  end
end
