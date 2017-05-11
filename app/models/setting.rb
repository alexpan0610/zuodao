class Setting < ApplicationRecord
  belongs_to :user
  belongs_to :receiving_info
end
