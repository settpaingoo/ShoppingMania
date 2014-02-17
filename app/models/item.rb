class Item < ActiveRecord::Base
  attr_accessible :name, :price, :stock, :brand_id, :category_id, :description

  belongs_to :brand
  belongs_to :category
end
