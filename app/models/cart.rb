class Cart < ApplicationRecord
  has_many :cart_items
  has_many :products, through: :cart_items, source: :product

  def get_items
    @items = cart_items.includes(:product, product: [:category])
  end

  def clean!
    cart_items.destroy_all
  end

  def add_product_to_cart(product, quantity)
    cart_item = cart_items.build
    cart_item.product = product
    cart_item.quantity = quantity
    cart_item.save
    return cart_item
  end

  def increase_product_quantity(product, quantity)
    cart_item = cart_items.find_by(product_id: product.id)
    cart_item.quantity = cart_item.quantity + quantity
    cart_item.save
    quantity = cart_item.quantity
  end

  def total_price
    sum = 0.0
    cart_items.each do |cart_item|
      if cart_item.product.price.present?
        sum += cart_item.quantity * cart_item.product.price
      end
    end
    sum
  end
end
