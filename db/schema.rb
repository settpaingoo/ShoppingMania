# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140225211344) do

  create_table "addresses", :force => true do |t|
    t.string   "street",     :null => false
    t.string   "city",       :null => false
    t.string   "state",      :null => false
    t.string   "zipcode",    :null => false
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "brands", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cart_items", :force => true do |t|
    t.integer  "cart_id",    :null => false
    t.integer  "item_id",    :null => false
    t.integer  "quantity",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cart_items", ["cart_id", "item_id"], :name => "index_cart_items_on_cart_id_and_item_id", :unique => true
  add_index "cart_items", ["cart_id"], :name => "index_cart_items_on_cart_id"
  add_index "cart_items", ["item_id"], :name => "index_cart_items_on_item_id"

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name",               :null => false
    t.integer  "parent_category_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "categories", ["parent_category_id"], :name => "index_categories_on_parent_category_id"

  create_table "items", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "price",       :null => false
    t.integer  "stock",       :null => false
    t.integer  "brand_id",    :null => false
    t.integer  "category_id", :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "items", ["brand_id"], :name => "index_items_on_brand_id"
  add_index "items", ["category_id"], :name => "index_items_on_category_id"

  create_table "order_items", :force => true do |t|
    t.integer  "order_id",   :null => false
    t.integer  "item_id",    :null => false
    t.integer  "price",      :null => false
    t.integer  "quantity",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "order_items", ["item_id"], :name => "index_order_items_on_item_id"
  add_index "order_items", ["order_id", "item_id"], :name => "index_order_items_on_order_id_and_item_id", :unique => true
  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "address_id", :null => false
  end

  add_index "orders", ["address_id"], :name => "index_orders_on_address_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "photos", :force => true do |t|
    t.integer  "item_id",            :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "photos", ["item_id"], :name => "index_photos_on_item_id"

  create_table "reviews", :force => true do |t|
    t.integer  "item_id",    :null => false
    t.integer  "user_id",    :null => false
    t.integer  "rating",     :null => false
    t.string   "title",      :null => false
    t.text     "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reviews", ["item_id", "user_id"], :name => "index_reviews_on_item_id_and_user_id", :unique => true
  add_index "reviews", ["item_id"], :name => "index_reviews_on_item_id"
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "tokens", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.string   "token_string", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "tokens", ["token_string"], :name => "index_tokens_on_token_string", :unique => true
  add_index "tokens", ["user_id"], :name => "index_tokens_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name",                         :null => false
    t.string   "last_name",                          :null => false
    t.string   "email",                              :null => false
    t.string   "password_digest",                    :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "is_admin",        :default => false
    t.string   "uid"
    t.boolean  "activated",       :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid"

  create_table "wishlist_items", :force => true do |t|
    t.integer  "wishlist_id", :null => false
    t.integer  "item_id",     :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "wishlist_items", ["item_id"], :name => "index_wishlist_items_on_item_id"
  add_index "wishlist_items", ["wishlist_id", "item_id"], :name => "index_wishlist_items_on_wishlist_id_and_item_id", :unique => true
  add_index "wishlist_items", ["wishlist_id"], :name => "index_wishlist_items_on_wishlist_id"

  create_table "wishlists", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wishlists", ["user_id"], :name => "index_wishlists_on_user_id"

end
