class CartItemsController < ApplicationController
  before_action :find_cart_item, only: [:destroy, :update, :increase_quantity, :decrease_quantity]
  respond_to :js

  def update
    @cart_item.update(cart_item_params)
    redirect_to carts_path
  end

  def increase_quantity
    change_quantity(@cart_item.product, 1)
		@cart_item.save
    respond_to do |format|
      format.js   { render layout: false }
    end
	end

	def decrease_quantity
		if @cart_item.quantity > 1
			change_quantity(@cart_item.product, -1)
			@cart_item.save
		end
    respond_to do |format|
      format.js   { render layout: false }
    end
	end

  def destroy
    product = @cart_item.product
    change_quantity(product, -@cart_item.quantity)
    @cart_item.destroy
    respond_to do |format|
      format.js   { render layout: false }
    end
  end

  private

  def change_quantity(product, quantity)
    @cart_item.product = product
    @cart_item.quantity += quantity
    product.quantity -= quantity
    product.save
  end

  def find_cart_item
    @cart = current_cart
    @cart_item = @cart.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
