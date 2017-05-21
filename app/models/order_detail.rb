# == Schema Information
#
# Table name: order_details
#
#  id          :integer          not null, primary key
#  image       :string
#  title       :string
#  description :text
#  price       :float
#  quantity    :integer          default("0")
#  order_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class OrderDetail < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :order
end
