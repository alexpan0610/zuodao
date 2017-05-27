# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  image       :string
#  title       :string
#  description :text
#  price       :float
#  quantity    :integer          default(0)
#  is_hidden   :boolean          default(TRUE)
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  catalog     :text
#

class Product < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :category
  has_many :course_relationships
  has_many :favorite_users, through: :course_relationships, source: :user

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :quantity, presence: true

  # 变更库存
  def change_stock!(quantity)
    self.quantity += quantity
    self.save
  end

  # 是否售罄
  def is_sold_out?
    self.quantity <= 0
  end
end
