# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  number         :string
#  payment_method :string
#  total_price    :float            default("0.0")
#  aasm_state     :string           default("placed")
#  name           :string
#  cellphone      :string
#  address        :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :cellphone, presence: true

  scope :recent, -> {order("created_at DESC")}

  include AASM
    aasm do
    state :placed, initial: true
    state :paid
    state :shipping
    state :shipped
    state :cancelled
    state :returend


    event :make_payment do
      transitions from: :placed, to: :paid
    end

    event :ship do
      transitions from: :paid,         to: :shipping
    end

    event :deliver do
      transitions from: :shipping,     to: :shipped
    end

    event :return_good do
      transitions from: :shipped,      to: :returend
    end

    event :cancel_order do
      transitions from: [:placed, :paid], to: :cancelled
    end
  end
end
