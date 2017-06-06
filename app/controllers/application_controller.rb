class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_categories
  helper_method :current_cart

  def admin_required
    if current_user.guest?
      flash[:alert] = "预览账户没有操作权限！"
      return back root_path
    end
    unless current_user.admin?
      redirect_to root_path, alert: "您没有权限！"
    end
  end

  def is_login?
    if !current_user
      redirect_to new_user_session_path, notice: "你需要登录后才能收藏课程！~"
    end
  end

  def current_cart
    # 如果用户登陆了，找到用户的专属购物车
    if current_user
      @current_cart ||= find_user_cart
    else
      @current_cart ||= find_session_cart
    end
  end

  private

  def load_categories
    @categories = Category.all
  end

  # 找一个临时购物车
  def find_session_cart
    cart = Cart.find_by(id: session[:cart_id]) || find_empty_cart
    session[:cart_id] = cart.id
    cart
  end

  # 找到用户的专属购物车
  def find_user_cart
    cart = current_user.cart
    if cart.nil?
      cart = find_empty_cart
      current_user.cart = cart
    end
    session_cart = find_session_cart
    # 将临时购物车中的课程加入用户的购物车
    unless session_cart.empty?
      cart.merge!(session_cart)
      session_cart.clean!
    end
    cart
  end

  # 找到一个空购物车
  def find_empty_cart
    # 找到所有不是用户专属的购物车
    carts = Cart.where(user_id: nil)
    if carts.empty?
      # 如果没有，新建一个
      return Cart.create
    else
      # 找到一个空购物车
      carts.each do |cart|
        return cart if cart.empty?
      end
      # 如果没有空购物车，新建一个
      return Cart.create
    end
  end

  def save_back_url
    session[:back_url] ||= request.referer
  end

  def back(path)
    redirect_to session.delete(:back_url) || path
  end
end
