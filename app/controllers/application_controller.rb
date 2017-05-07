class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_common_data
  helper_method :current_cart

  def admin_required
    unless current_user.admin?
      redirect_to root_path, alert: "您没有权限！"
    end
  end

  def current_cart
    @current_cart ||= get_cart
  end

  private

  def load_common_data
    @categories = Category.all
    @cart_items = current_cart.get_items
  end

  def get_cart
    cart = Cart.find_by(id: session[:cart_id])
    if cart.blank?
      cart = Cart.create
    end
    session[:cart_id] = cart.id
    return cart
  end

  def back(path)
    redirect_to request.referer || path
  end
end
