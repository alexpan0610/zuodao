module Admin::OrdersHelper

  def render_payment_method(order)
    case order.payment_method
    when "alipay"
      "支付宝"
    when "wechat"
      "微信支付"
    end
  end
end
