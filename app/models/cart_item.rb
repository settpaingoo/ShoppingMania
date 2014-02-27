class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :item_id, :quantity

  validates :cart, :item, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :item_id, uniqueness: { scope: :cart_id }

  belongs_to :cart
  belongs_to :item

  def subtotal
    item.price * quantity
  end

end
