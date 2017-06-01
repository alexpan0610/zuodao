# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders
  has_many :addresses
  has_many :course_relationships
  has_many :favorited_courses, through: :course_relationships, source: :product

  has_one :cart
  has_one :setting
  has_one :default_address, through: :setting, source: :address


  validates :email, presence: true
  validates :password, presence: true

  scope :asc, -> { order("created_at ASC") }

  def admin?
    is_admin
  end

  def favorite!(course)
    favorited_courses << course
  end

  def dislikes!(course)
    favorited_courses.delete(course)
    course.favorites_count -= 1
  end

  def favorited?(course)
    favorited_courses.include?(course)
  end
end
