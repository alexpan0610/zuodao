# == Schema Information
#
# Table name: receiving_infos
#
#  id         :integer          not null, primary key
#  name       :string
#  cellphone  :string
#  address    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ReceivingInfo < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :address, presence: true
  validates :cellphone, presence: true
end
