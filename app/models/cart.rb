# == Schema Information
#
# Table name: carts
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  cart_items_count :integer          default("0")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :products, through: :cart_items, source: :product

  def empty?
    cart_items_count == 0
  end

  def merge!(cart)
    cart.cart_items.each do |item|
      add(item.product, item.quantity)
    end
  end

  def clean!
    cart_items.destroy_all
  end

  def get_items
    @cart_items = cart_items.includes(:product)
  end

  def add(product, quantity)
    if products.include?(product)
      @cart_item = cart_items.find_by(product_id: product.id)
    else
      @cart_item = cart_items.build
    end
    change_quantity(product, quantity)
    @cart_item.save
  end

  def change_quantity(product, quantity)
    @cart_item.product = product
    @cart_item.quantity += quantity
    product.quantity -= quantity
    product.save
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
