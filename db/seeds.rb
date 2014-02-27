USERS_COUNT = 10
users = []
USERS_COUNT.times do |i|
  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "user#{i + 1}@example.com",
    password: "mypassword"
  )
  user.activated = true
  users << user
end

admin = User.new(
  first_name: "Admin",
  last_name: Faker::Name.last_name,
  email: "admin@example.com",
  password: "mypassword"
)
admin.is_admin = true
admin.activated = true
users << admin
User.import users

carts = []
(USERS_COUNT + 1).times { |i| carts << Cart.new(user_id: (i + 1)) }
Cart.import carts

Wishlist.create(user_id: 1, name: "My favorites")
Wishlist.create(user_id: 1, name: "Things I want")


CATEGORIES = ["Men", "Women", "Juniors", "Kids", "Baby", "Accessories"]
categories = []

CATEGORIES.each do |category_name|
  categories << Category.new(name: category_name)
end
Category.import categories


BRANDS = ["Calvin Klein", "True Religion", "Guess", "Diesel", "Levi's", "American Eagle", "Hurley", "Columbia", "Nautica", "Rayban"]
brands = []

BRANDS.each do |brand_name|
  brands << Brand.new(name: brand_name)
end
Brand.import brands


ITEM_ADJ = %w(Solid Striped Dots Plain Dress Party Work Casual Denim)
ITEM_NOUN = %w(Shirt Polo Pants Skirt Coat Jacket Blazer Sweater Tie Hat Scarf Belt Wallet Sunglasses)

category_count = categories.count
brand_count = brands.count
def generate_item_name(brand_id)
  brand = BRANDS[brand_id - 1]
  adj = ITEM_ADJ.sample
  noun = ITEM_NOUN.sample

  "#{brand} #{adj} #{noun}"
end

ITEMS_COUNT = 10
items = []
(ITEMS_COUNT - 2).times do
  brand_id = rand(1..brand_count)
  items << Item.new(
    name: generate_item_name(brand_id),
    price: rand(10..300),
    stock: rand(1..40),
    brand_id: brand_id,
    category_id: rand(1..category_count)
  )
end
2.times do
  brand_id = rand(1..brand_count)
  items << Item.new(
    name: generate_item_name(brand_id),
    price: rand(10..300),
    stock: 0,
    brand_id: brand_id,
    category_id: rand(1..category_count)
  )
end
Item.import items


PHOTO_URLS = [
"http://ecx.images-amazon.com/images/I/41kDkSy8sjL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41mzrkbWt7L._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41j5iz9Jh%2BL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41gm5HKAABL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41b48qjtxXL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/51lviBVkdmL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41qXfwmk5FL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41XR-NQViZL._SL190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/51bjKyO3DLL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41BaxfsrQ5L._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41A9LLu%2Bu7L._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/412DCj6J4AL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/31DCTX6dM8L._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/3173PKODPCL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41Bl5jvDnnL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41GeGn-S73L._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/31yh3gjq%2BgL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/31TlDeSZ%2BGL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41v%2Bk8ZrqQL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/419iqD-5qpL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41FLteUCgGL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41tcDGvw9mL._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41h3lVkKC2L._SL246_SX190_CR0,0,190,246_.jpg",
"http://ecx.images-amazon.com/images/I/41sVr%2Bm4B7L._SL246_SX190_CR0,0,190,246_.jpg"
]

ITEMS_COUNT.times do |i|
  rand(1..3).times do
    Photo.create(item_id: i + 1, image: open(PHOTO_URLS.sample))
  end
end


GOOD_REVIEWS = [
  "Love this item",
  "Would recommend this to my friends",
  "Really enjoyed using this product",
  "My new favorite item",
  "Worth the price",
  "Would buy again and again",
  "Quality is amazing",
  "Love this product",
  "Amazing product",
  "Never been happier to receive a product",
  "My daughter loves this",
  "Best present you can buy for your beloved one"
]
BAD_REVIEWS = [
  "Bad quality",
  "Don't like this",
  "Could have bought something better",
  "Not worth the price",
  "Will never buy this again",
  "Waste of money",
  "Worst product ever",
  "I don't like this",
  "Broke on the first day",
  "Doesn't last long"
]

def generate_review(rating, sentence_count = 1)
  reviews = rating > 2 ? GOOD_REVIEWS : BAD_REVIEWS
  if sentence_count == 1
    reviews.sample
  else
    "#{reviews.sample(sentence_count).join(". ")}."
  end
end

reviews = []
item_ids = (1..ITEMS_COUNT).to_a
USERS_COUNT.times do |i|
  item_ids.sample(rand(3..10)).each do |item_id|
    rating = rand(1..5)
    reviews << Review.new(
      item_id: item_id,
      user_id: i + 1,
      rating: rating,
      title: generate_review(rating),
      body: generate_review(rating, rand(2..5))
    )
  end
end
Review.import reviews


cart_items = []
(1..ITEMS_COUNT).to_a.sample(5).each do |item_id|
  cart_items << CartItem.new(
    cart_id: 1,
    item_id: item_id,
    quantity: rand(1..5)
  )
end
CartItem.import cart_items

wishlist_items = []
(1..ITEMS_COUNT).to_a.sample(7).each do |item_id|
  wishlist_items << WishlistItem.new(
    wishlist_id: rand(1..2),
    item_id: item_id
  )
end
WishlistItem.import wishlist_items

Address.create(user_id: 1, street: "770 Broadway", city: "Manhattan", state: "NY", zipcode: "10003")
Order.create(user_id: 1, address_id: 1)
order_items = []
(1..ITEMS_COUNT).to_a.sample(5).each do |item_id|
  order_items << OrderItem.new(
    order_id: 1,
    item_id: item_id,
    price: rand(10..300),
    quantity: rand(1..5)
  )
end
OrderItem.import order_items