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
  before_create :generate_number
  belongs_to :user
  has_many :order_details, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :cellphone, presence: true

  scope :recent, -> {order("created_at DESC")}

  # 生成订单号
  def generate_number
    # 下单时间 + 随机序列
    self.number = Date.today.strftime("%Y%m%d") + SecureRandom.uuid[-12,12].upcase;
  end

  include AASM
    aasm do
    state :placed, initial: true
    state :paid
    state :applying_for_cancel
    state :shipping
    state :shipped
    state :applying_for_return
    state :cancelled
    state :returned

    event :make_payment do
      transitions from: :placed, to: :paid
    end

    event :apply_for_cancel do
      transitions from: [:placed, :paid], to: :applying_for_cancel
    end

    event :cancel do
      transitions from: :applying_for_cancel, to: :cancelled
    end

    event :ship do
      transitions from: :paid, to: :shipping
    end

    event :confirm_receipt do
      transitions from: :shipping, to: :shipped
    end

    event :apply_for_return do
      transitions from: :shipped, to: :applying_for_return
    end

    event :confirm_goods_returned do
      transitions from: :applying_for_return, to: :returned
    end
  end
end
