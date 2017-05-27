# == Schema Information
#
# Table name: course_relationships
#
#  id         :integer          not null, primary key
#  product_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CourseRelationship < ApplicationRecord
  belongs_to :product, counter_cache: :favorites_count
  belongs_to :user
end
