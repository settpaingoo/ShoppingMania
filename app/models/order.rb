class Order < ActiveRecord::Base
  attr_accessible :user_id, :address_id

  validates :user, :address, presence: true

  belongs_to :user
  belongs_to :address
  has_many :order_items, inverse_of: :order, include: :item

  after_commit :switch_user_carts

  def checkout(cart)
    Order.transaction do
      self.save!

      order_items = []
      cart.cart_items.each do |cart_item|
        order_items << OrderItem.new(
          order_id: self.id,
          item_id: cart_item.item_id,
          price: cart_item.item.price,
          quantity: cart_item.quantity
        )
      end

      OrderItem.import order_items
    end
  end

  def total
    order_items.map(&:subtotal).inject(:+)
  end

  def switch_user_carts
    user.cart.destroy
    user.create_cart
  end
end
