# == Schema Information
#
# Table name: carts
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  cart_items_count :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Cart < ApplicationRecord
  has_many :cart_items
  has_many :products, through: :cart_items, source: :product

  def empty?
    cart_items_count == 0
  end

  def merge!(cart)
    cart.cart_items.each do |item|
      add!(item.product, item.quantity)
    end
  end

  def clean!
    cart_items.destroy_all
  end

  def get_items
    @cart_items = cart_items.includes(:product)
  end

  def add!(product, quantity)
    # 商品已经在购物车中，增加商品的数量
    if products.include?(product)
      @cart_item = cart_items.find_by_product_id(product.id)
    else
      @cart_item = cart_items.build
      @cart_item.product = product
    end
    # 限制购物车商品数不超过库存
    @cart_item.change_quantity!(quantity) if @cart_item.quantity + quantity <= product.quantity
  end

  def total_price(items = nil)
    if items.nil?
      items = cart_items
    end
    total = 0.0
    items.each do |item|
      if item.product.price.present?
        total += item.quantity * item.product.price
      end
    end
    total.round(4)
  end
end
