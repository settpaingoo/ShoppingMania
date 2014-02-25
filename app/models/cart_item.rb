class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :item_id, :quantity

  validates :cart, :item, :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :item_id, uniqueness: { scope: :cart_id }

  belongs_to :cart
  belongs_to :item, include: :photos

  #after destroy callback
  def remove
    item = Item.find(item_id)

    if item.add_stock(quantity)
      self.destroy
      true
    else
      false
    end
  end

  def subtotal
    item.price * quantity
  end

  def modify(new_quantity)
    raise "error" if new_quantity < 0
    return remove if new_quantity == 0

    difference = new_quantity - quantity
    return self if difference == 0

    item = Item.find(item_id)
    CartItem.transaction do
      if difference > 0
        item.remove_stock(difference)
      elsif difference < 0
        item.add_stock(difference.abs)
      end

      self.quantity = new_quantity
      self.save!
    end

    self
  end
end
