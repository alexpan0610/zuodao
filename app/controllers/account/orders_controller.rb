class Account::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.page(params[:page]).per_page(10)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end
end
