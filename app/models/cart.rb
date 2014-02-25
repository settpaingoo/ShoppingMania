class Cart < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user
  has_many :cart_items, dependent: :destroy, include: :item

  def add_item(item_id, quantity)
    item = Item.find(item_id)
    cart_item = CartItem.where("cart_id = ? AND item_id = ?", self.id, item_id).first

    if cart_item
      new_quantity = cart_item.quantity + quantity
      cart_item.modify(new_quantity)
    else
      Cart.transaction do
        item.remove_stock(quantity)
        cart_item = self.cart_items.new(item_id: item_id, quantity: quantity)
        self.save!
      end
    end
  end

  def total
    cart_items.map(&:subtotal).inject(:+)
  end
end
