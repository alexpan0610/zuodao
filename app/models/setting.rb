# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  address_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Setting < ApplicationRecord
  belongs_to :user
  belongs_to :address
end
