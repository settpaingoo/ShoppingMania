class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :item_id, :price, :quantity

  validates :order, :item, :price, :quantity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :item_id, uniqueness: { scope: :order_id }

  belongs_to :order
  belongs_to :item, include: :photos

  def subtotal
    price * quantity
  end
end
