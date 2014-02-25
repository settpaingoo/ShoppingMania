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

  def combine(another_cart)
    return self if self.user_id && another_cart.user_id

    if self.cart_items.length >= another_cart.cart_items.length
      begin
        Cart.transaction do
          self.user_id ||= another_cart.user_id
          self.save!

          another_cart.cart_items.each do |cart_item|
            self.add_item(cart_item.item_id, cart_item.quantity)
          end

          another_cart.destroy
        end
      rescue
      ensure
        return self
      end
    else
      another_cart.combine(self)
    end
  end
end
