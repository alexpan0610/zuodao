class CartItemsController < ApplicationController
  before_action :find_cart_item, only: [:update, :increase, :decrease, :destroy]
  respond_to :js, only: [:decrease, :increase]

  def update
    @cart_item.update(cart_item_params)
    redirect_to carts_path
  end

  def increase
    # 检查库存
    if @cart_item.product.quantity > 0
      change_quantity(1)
    end
	end

	def decrease
    # 购物车中的商品数量最少为1件
		if @cart_item.quantity > 1
			change_quantity(-1)
		end
	end

  def destroy
    change_quantity(-@cart_item.quantity)
    @cart_item.destroy
    respond_to do |format|
      format.js { render "carts/delete_item"}
    end
  end
  
  private

  def find_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
