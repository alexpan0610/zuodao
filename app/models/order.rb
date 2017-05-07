# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  name       :string
#  cellphone  :string
#  address    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :cellphone, presence: true

  scope :recent, -> {order("created_at DESC")}
end
