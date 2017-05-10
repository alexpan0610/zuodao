class CartItemsController < ApplicationController
  before_action :find_cart_item, only: [:destroy, :update, :increase, :decrease]
  respond_to :js

  def update
    @cart_item.update(cart_item_params)
    redirect_to carts_path
  end

  def increase
    change_quantity(1)
    respond_to do |format|
      format.js   { render layout: false }
    end
	end

	def decrease
		if @cart_item.quantity > 1
			change_quantity( -1)
		end
    respond_to do |format|
      format.js   { render layout: false }
    end
	end

  def destroy
    @product = @cart_item.product
    change_quantity(-@cart_item.quantity)
    @cart_item.destroy
    respond_to do |format|
      format.js   { render layout: false }
    end
  end

  private

  def change_quantity(quantity)
    @product = @cart_item.product
    @cart_item.quantity += quantity
    @product.quantity -= quantity
    @cart_item.save
    @product.save
  end

  def find_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
