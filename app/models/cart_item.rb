class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :item_id, :quantity

  validates :cart, :item, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :item_id, uniqueness: { scope: :cart_id }

  belongs_to :cart
  belongs_to :item

  #call_backs are probably better
  def remove
    item = Item.find(item_id)

    if item.add_stock(quantity)
      self.destroy
      return true
    end

    false
  end

  def subtotal
    item.price * quantity
  end

  def modify(new_quantity)
    return false if new_quantity < 0
    return remove if new_quantity == 0

    difference = new_quantity - quantity
    return true if difference == 0

    item = Item.find(item_id)
    if difference > 0 && item.remove_stock(difference)
      self.quantity = new_quantity
      self.save
    elsif difference < 0 && item.add_stock(difference.abs)
      self.quantity = new_quantity
      self.save
    end
  end
end
