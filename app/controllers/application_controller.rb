class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_categories
  helper_method :current_cart

  def admin_required
    unless current_user.admin?
      redirect_to root_path, alert: "您没有权限！"
    end
  end

  def current_cart
    if current_user
      @current_cart ||= get_user_cart
    else
      @current_cart ||= get_session_cart
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

  def load_categories
    @categories = Category.all
  end

  def get_session_cart
    cart = Cart.find_by(id: session[:cart_id])
    if cart.blank?
      cart = Cart.create
    end
    session[:cart_id] = cart.id
    return cart
  end

  def get_user_cart
    cart = current_user.cart
    if cart.blank?
      cart = Cart.create
      current_user.cart = cart
    end
    session_cart = get_session_cart
    unless session_cart.empty?
      cart.merge(session_cart)
    end
    return cart
  end

  def back(path)
    redirect_to request.referer || path
  end
end
