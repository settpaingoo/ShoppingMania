#make sure to create carts for users
USERS_COUNT = 10
users = []
USERS_COUNT.times do |i|
  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "user#{i + 1}@example.com",
    password: "password"
  )
  user.activated = true
  users << user
end

admin = User.new(
  first_name: "Admin",
  last_name: Faker::Name.last_name,
  email: "admin@example.com",
  password: "password"
)
admin.is_admin = true
admin.activated = true
users << admin
User.import users

CATEGORIES = ["Men", "Women", "Juniors", "Kids", "Baby", "Accessories"]
categories = []

CATEGORIES.each do |category_name|
  categories << Category.new(name: category_name)
end
Category.import categories

BRANDS = ["Calvin Klein", "True Religion", "Guess", "Diesel", "Levi's", "American Eagle"]
brands = []

BRANDS.each do |brand_name|
  brands << Brand.new(name: brand_name)
end
Brand.import brands

category_count = categories.count
brand_count = brands.count

ITEMS_COUNT = 25
items = []
ITEMS_COUNT.times do
  items << Item.new(
    name: Faker::Commerce.product_name,
    price: rand(10..300),
    stock: rand(40),
    brand_id: rand(1..brand_count),
    category_id: rand(1..category_count)
  )
end
Item.import items

ITEMS_COUNT.times do |i|
  rand(1..3).times do
    width = rand(100..600)
    height = rand(100..600)
    Photo.create(item_id: i + 1, image: open("http://placekitten.com/#{width}/#{height}"))
  end
end

reviews = []
USERS_COUNT.times do |i|
  item_ids = []
  rand(0..10).times { item_ids << rand(1..ITEMS_COUNT) } # use array#sample
  item_ids.uniq.each do |item_id|
    reviews << Review.new(
      item_id: item_id,
      user_id: i + 1,
      rating: rand(1..5),
      title: Faker::Lorem.words(rand(3..6)).join(" "),
      body: Faker::Lorem.sentences(rand(2..5)).join("\n")
    )
  end
end
Review.import reviews