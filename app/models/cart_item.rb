# == Schema Information
#
# Table name: cart_items
#
#  id               :integer          not null, primary key
#  cart_id          :integer
#  product_id       :integer
#  cart_items_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CartItem < ApplicationRecord
  belongs_to :cart, dependent: :destroy, counter_cache: true
  belongs_to :product
end
