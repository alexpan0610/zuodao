class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
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

  def get_products
    if params[:category].blank?
      @products = Product.order('created_at DESC')
    else
      @products = Product.where(category_id: params[:category].to_i)
    end
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
