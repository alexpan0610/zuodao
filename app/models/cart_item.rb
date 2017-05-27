# == Schema Information
#
# Table name: cart_items
#
#  id         :integer          not null, primary key
#  cart_id    :integer
#  product_id :integer
#  quantity   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CartItem < ApplicationRecord
  belongs_to :cart, counter_cache: true
  belongs_to :product

  # 变更数量
  def change_quantity!(quantity)
    self.quantity += quantity
    self.save
    self
  end
end
