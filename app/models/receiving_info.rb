class ReceivingInfo < ApplicationRecord
  belongs_to :user

  validates :name, present: true
  validates :address, present: true
  validates :cellphone, present: true
end
