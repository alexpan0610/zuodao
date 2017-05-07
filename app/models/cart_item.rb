class CartItem < ApplicationRecord
  belongs_to :cart, dependent: :destroy, counter_cache: true
  belongs_to :product
end
