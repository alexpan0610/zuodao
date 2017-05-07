class Admin::OrdersController <  AdminController
    before_action :find_order, only: [:show, :ship, :shipped, :cancel, :return]

  def index
    if params[:start_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today
      @orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      respond_to do |format|
        format.html
        format.xlsx {
          response.headers['Content-Disposition'] = 'attachment; filename="Orders #{start_date}-#{end_date}.xlsx"'
        }
      end
    else
      @orders = Order.includes(:user).recent
    end
    @orders = @orders.page(params[:page]).per_page(20)
  end

  def show
    @product_lists = @order.product_lists
  end

  def ship
    @order.ship!
    OrderMailer.notify_ship(@order).deliver!
    redirect_to :back
  end

  def shipped
    @order.deliver!
    redirect_to :back
  end

  def cancel
    @order.cancell_order!
    OrderMailer.notify_cancel(@order).deliver!
    redirect_to :back
  end

  def return
    @order.return_good!
    redirect_to :back
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
end
