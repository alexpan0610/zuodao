# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  images      :string
#  title       :string
#  description :text
#  price       :float
#  quantity    :integer          default("0")
#  is_hidden   :boolean          default("t")
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Product < ApplicationRecord
  mount_uploaders :images, ImageUploader
  serialize :images, JSON

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
end
