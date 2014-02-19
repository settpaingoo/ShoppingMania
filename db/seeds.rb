# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([
  {first_name: "User", last_name: "One",
    email: "userone@test.com", password: "password"}
])

user = User.create(
  {first_name: "User", last_name: "Admin",
    email: "admin@test.com", password: "password"}
)

user.is_admin = true
user.save!

Category.create([
  {name: "Men"},
  {name: "Women"},
  {name: "Juniors"}
])

Brand.create([
  {name: "American Eagle"},
  {name: "Abercrombie & Fitch"},
  {name: "Levi's"}
])

Item.create([
  {name: "Classic Jacket", price: 60, stock: 40,
    brand_id: 2, category_id: 1},
  {name: "Classic Jeans", price: 30, stock: 70,
    brand_id: 3, category_id: 1},
  {name: "Weatherproof Jacket", price: 80, stock: 30,
    brand_id: 2, category_id: 1},
  {name: "Polo Shirt", price: 25, stock: 60,
    brand_id: 1, category_id: 1},
  {name: "Party Dress", price: 120, stock: 30,
    brand_id: 2, category_id: 2},
])