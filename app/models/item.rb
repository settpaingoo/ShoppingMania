class Item < ActiveRecord::Base
  attr_accessible :name, :price, :stock, :brand_id, :category_id, :description

  belongs_to :brand, inverse_of: :items
  belongs_to :category, inverse_of: :items

  has_many :cart_items
end
