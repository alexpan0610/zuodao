class Account::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_order, only: :create

  def index
    @orders = current_user.orders.page(params[:page]).per_page(10)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def create
    # 生成订单
    create_order
    # 生成购物清单
    create_order_details
    # 回到商品列表
    redirect_to products_path
  end

  private

  # 检查订单信息
  def check_order
    # 获取购物清单
    @items = CartItem.where(id: params[:items])
    # 获取收获地址
    @address = Address.find(params[:selected_address])
    if @address.nil?
      error(:warning, "请选择一个收货地址！")
    end
    # 获取支付方式
    @payment = params[:payment_method]
    if @payment.nil?
      error(:warning, "请选择一个支付方式！")
    end
  end

  # 生成订单
  def create_order
    @order = Order.new(@address.attributes.except!("id", "label"))
    @order.payment_method = @payment
    @order.total_price = current_cart.calculate_total_price(@items)
    @order.user = current_user
    unless @order.save
      error(:alert, "生成订单出错！")
    end
    # 生成订单号
    @order.update(number: generate_order_number)
  end

  # 生成购物清单
  def create_order_details
    @order_details = []
    @items.each do |item|
      # 生成订单详情
      @order_detail = OrderDetail.new(item.product.attributes.except!("id", "is_hidden", "category_id"))
      @order_detail.quantity = item.quantity
      @order_detail.order = @order
      unless @order_detail.save
        error(:alert, "生成购物清单出错！")
      end
      # 移出购物车
      current_cart.cart_items.delete(item)
    end
  end

  def error(level, msg)
    flash[level] = msg
    redirect_to checkout_cart_path(current_cart, selections: params[:items])
  end

  # 生成订单号
  def generate_order_number
    # 下单时间 + 订单编号
    Date.today.strftime("%Y%m%d") + "%.4d" % @order.id
  end
end
