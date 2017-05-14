class Account::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_order, only: :create
  before_action :find_order_by_id, only: [:pay, :apply_cancel, :return_goods]

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
    # 前往支付页
    redirect_to pay_account_order_path(@order)
  end

  # 支付页
  def pay
  end

  # 完成支付
  def make_payment
    @order.make_payment
    operation_error(:notice, "订单支付成功！")
  end

  # 取消订单
  def apply_cancel
    if @order.placed || @order.paid
      # 取消订单
      @order.cancel!
      operation_error(:notice, "订单#{@order.number}取消成功！")
    elsif @order.cancelled
      # 订单已经取消
      operation_error(:warning, "订单#{@order.number}已经取消，不能重复取消！")
    elsif @order.shipping || @order.shipped
      # 订单已经出货
      operation_error(:warning, "您的订单#{@order.number}已经出货，请您申请退货！")
    elsif @order.applying_for_return
      # 申请退货中
      operation_error(:warning, "您的订单#{@order.number}正在申请退货，不能取消！")
    else
      # 其他情况
      operation_error(:alert, "您的订单#{@order.number}取消失败！")
    end
  end

  # 确认收货
  def confirm_receipt
    if @order.shipping
      # 订单正在配送
      @order.confirm_receipt!
      operation_error(:notice, "您的订单#{@order.number}成功确认收货！")
    elsif @order.cancelled
      # 订单已经取消
      operation_error(:warning, "您的订单#{@order.number}已经取消！")
    elsif @order.shipped
      # 订单已经确认收货
      operation_error(:warning, "您的订单#{@order.number}已经确认收货，不能重复确认收货！")
    elsif @order.returned
      operation_error(:warning, "您的订单#{@order.number}已经退货！")
    else
      # 其他情况
      operation_error(:alert, "您的订单#{@order.number}确认收货失败！")
    end
  end

  # 申请退货
  def apply_for_return
    if @order.shipping || @order.shipped
      # 订单正在配送或送达
      @order.apply_for_return!
      operation_error(:notice, "订单#{@order.number}的退货申请已经提交！")
    elsif @order.cancelled
      # 订单已经取消
      operation_error(:warning, "您的订单#{@order.number}已经取消！")
    elsif @order.returned
      operation_error(:warning, "您的订单#{@order.number}已经退货！")
    else
      # 其他情况
      operation_error(:alert, "您的订单#{@order.number}申请退货失败！")
    end
  end

  private

  # 检查订单信息
  def check_order
    # 获取购物清单
    @items = CartItem.where(id: params[:items])
    # 获取收获地址
    if params[:selected_address] == "none"
      return checkout_error(:warning, "请选择一个收货地址！")
    end
    @address = Address.find(params[:selected_address])
    # 获取支付方式
    if params[:payment_method] == "none"
      return checkout_error(:warning, "请选择一个支付方式！")
    end
    @payment = params[:payment_method]
  end

  # 生成订单
  def create_order
    @order = Order.new(@address.attributes.except!("id", "label"))
    @order.payment_method = @payment
    @order.total_price = current_cart.calculate_total_price(@items)
    @order.user = current_user
    unless @order.save
      checkout_error(:alert, "生成订单出错！")
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
        checkout_error(:alert, "生成购物清单出错！")
      end
      # 移出购物车
      current_cart.cart_items.delete(item)
    end
  end

  # 生成订单号
  def generate_order_number
    # 下单时间 + 订单编号
    Date.today.strftime("%Y%m%d") + "%.4d" % @order.id
  end

  # 处理订单生成异常
  def checkout_error(level, msg)
    flash[level] = msg
    redirect_to checkout_cart_path(current_cart, selections: params[:items])
  end

  # 处理用户操作异常
  def operation_error(level, msg)
    flash[level] = msg
    redirect_back
  end

  def find_order_by_id
    @order = Order.find(params[:id])
  end
end
