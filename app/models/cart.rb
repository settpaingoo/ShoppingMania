class Cart < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user
  has_many :cart_items, dependent: :destroy, include: :item

  #how to change to transaction
  def add_item(item_id, quantity)
    item = Item.find(item_id)
    if item.remove_stock(quantity)
      self.cart_items.new(item_id: item_id, quantity: quantity)
      self.save
    end
  end

  def total
    cart_items.map(&:subtotal).inject(:+)
  end

  def checkout
    order = user.orders.new
    if order.add_items(self)
      self.destroy
      return true
    end

    false
  end
end
