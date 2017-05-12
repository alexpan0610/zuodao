module CartsHelper

  def calculate_total_price(items)
    num = 0.0
    items.each do |item|
      num += item.product.price * item.quantity
    end
    return render_price(num)
  end
end
