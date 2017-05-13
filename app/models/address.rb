# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  label      :string
#  name       :string
#  cellphone  :string
#  address    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ApplicationRecord
  belongs_to :user

  validates :label, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :cellphone, presence: true

  def default?
    self == self.user.default_address
  end
end
