class Admin::OrdersController <  Admin::AdminController
  before_action :find_order_by_id, only: [:show, :ship, :shipped, :cancel, :return]

  def index
    if params[:start_date].present?
      start_date = Date.strptime(params[:start_date], "%m/%d/%Y")
      end_date = params[:end_date].present? ? Date.strptime(params[:end_date], "%m/%d/%Y") : Date.today
      @orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    else
      @orders = Order.includes(:user).recent
    end
    @orders = @orders.page(params[:page]).per_page(20)
  end

  def show
    @order_details = @order.order_details
  end

  # 取消订单
  def cancel
    @order.cancel!
    redirect_back
  end

  # 发货
  def ship
    @order.ship!
    redirect_back
  end

  # 确认退货
  def confirm_goods_returned
    @order.confirm_goods_returned!
    redirect_back
  end

  private

  def find_order_by_id
    @order = Order.find(params[:id])
  end
end
