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
#  role_type              :integer          default(0)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  has_many :orders
  has_many :addresses
  has_many :course_relationships
  has_many :favorited_courses, through: :course_relationships, source: :product
  has_many :identifies

  has_one :cart
  has_one :setting
  has_one :default_address, through: :setting, source: :address

  validates :email, presence: true
  validates :password, presence: true

  scope :asc, -> { order("created_at ASC") }

  def admin?
    role_type == 31
  end

  def guest?
    role_type == 13
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

  # 第三方登录的用户
  def self.identify(access_token, signed_in_resoruce=nil)
		data = access_token.info
		identify = Identify.find_by(provider: access_token.provider, uid: access_token.uid)

		if identify
			return identify.user
		else
			user = User.find_by(email: data.email || access_token.email)
			if !user
				user = User.create(
					email: data.email,
					password: Devise.friendly_token[0,20]
				)
			end
			identify = Identify.create(
				provider: access_token.provider,
				uid: access_token.uid,
				user: user
			)
			return user
		end
  end
end
