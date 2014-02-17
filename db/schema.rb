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

ActiveRecord::Schema.define(:version => 20140217203153) do

  create_table "brands", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "tokens", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.string   "token_string", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "tokens", ["token_string"], :name => "index_tokens_on_token_string", :unique => true

  create_table "users", :force => true do |t|
    t.string   "first_name",      :null => false
    t.string   "last_name",       :null => false
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
