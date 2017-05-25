class OrderMailer < ApplicationMailer

  # 发送订单确认通知(to user)
  def notify_order_placed(order)
    mail(to: to_user(order) , subject: "[做到] 感谢您完成本次下单，订单号#{order.number}")
  end

  # 订单支付通知(to admin)
  def notify_order_paid(order)
    mail(to: to_admin(order) , subject: "[做到] 订单#{order.number}已经完成支付。")
  end

  # 申请取消订单通知(to admin)
  def notify_apply_cancel(order)
    mail(to: to_admin(order) , subject: "[做到] 订单#{order.number}提交了取消申请。")
  end

  # 订单发货通知(to user)
  def notify_order_shipping(order)
    mail(to: to_user(order) , subject: "[做到] 您的订单#{order.number}已经发货，请您注意查收。")
  end

  # 确认收货通知(to admin)
  def notify_order_receipt(order)
    mail(to: to_admin(order) , subject: "[做到] 订单#{order.number}已经确认收货。")
  end

  # 订单完成通知
  def notify_order_finished(order)
    mail(to: to_user(order) , subject: "[做到] 您的订单#{order.number}已经完成，感谢您对[做到]的支持！")
  end

  # 申请退货通知(to admin)
  def notify_apply_return(order)
    mail(to: to_admin(order) , subject: "[做到] 订单#{order.number}提交了退货申请。")
  end

  # 订单取消通知(to user)
  def notify_order_cancelled(order)
    mail(to: to_user(order) , subject: "[做到] 您的订单#{order.number}已经取消。")
  end

  # 确认退货通知(to user)
  def notify_goods_returned(order)
    mail(to: to_user(order) , subject: "[做到] 您的订单#{order.number}已经完成退货。")
  end

  private

  def to_user(order)
    @order = order
    @user = order.user
    @order_details = @order.order_details
    @user.email
  end

  def to_admin(order)
    to_user(order)
    "ppgod@live.cn"
  end
end
