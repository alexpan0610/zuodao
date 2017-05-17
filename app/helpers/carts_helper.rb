module CartsHelper

  def calculate_total_price(items)
    render_price(current_cart.calculate_total_price(items))
  end
end
