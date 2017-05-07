# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Product.delete_all
Category.delete_all

User.create!(
email: "ppgod@live.cn",
password: "12345678",
is_admin: true
)

category = Category.create!(
name: "认知学习法"
)

10.times do
  Product.create!(
  title: Faker::App.name,
  description: Faker::Lorem.sentence,
  price: Faker::Number.decimal(4,2),
  quantity: Faker::Number.number(3),
  category: category
  )
end

category = Category.create!(
name: "千古营销课"
)

10.times do
  Product.create!(
  title: Faker::App.name,
  description: Faker::Lorem.sentence,
  price: Faker::Number.decimal(4,2),
  quantity: Faker::Number.number(3),
  category: category
  )
end
