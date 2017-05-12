# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  receiving_info_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Setting < ApplicationRecord
  belongs_to :user
  belongs_to :receiving_info
end
