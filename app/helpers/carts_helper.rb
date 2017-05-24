module CartsHelper

  def calculate_total_price(items)
    render_price(current_cart.total_price(items))
  end
end
