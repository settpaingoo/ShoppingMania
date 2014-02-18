class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :item_id, :price, :quantity

  validates :order, :item, :price, :quantity, presence: true
  validates :item_id, uniqueness: { scope: :order_id }

  belongs_to :order
  belongs_to :item
end
