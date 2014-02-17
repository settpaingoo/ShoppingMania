class Cart < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user, inverse_of: :carts

  has_many :cart_items
  has_many :items, through: :cart_items
end
