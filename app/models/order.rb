class Order < ActiveRecord::Base
  attr_accessible :user_id, :address_id

  validates :user, :address, presence: true

  belongs_to :user
  belongs_to :address
  has_many :order_items, inverse_of: :order, dependent: :destroy

  after_commit :empty_cart

  def checkout(cart)
    Order.transaction do
      self.save!

      order_items = []
      cart.cart_items.each do |cart_item|
        item = cart_item.item
        quantity = cart_item.quantity

        item.remove_stock!(quantity)
        order_items << OrderItem.new(
          order_id: self.id,
          item_id: item.id,
          price: item.price,
          quantity: quantity
        )
      end

      OrderItem.import order_items
    end
  end

  def total
    order_items.map(&:subtotal).inject(:+)
  end

  def empty_cart
    user.cart.cart_items.destroy_all
  end
end
