class Order < ActiveRecord::Base
  attr_accessible :user_id

  validates :user, presence: true

  belongs_to :user
  has_many :order_items, inverse_of: :order, include: :item

  #make_sure to avoid (n+1) queries
  #use import to bulk insert all cart_items
  def self.create_new_order(cart)
    order = Order.new(user_id: cart.user_id)

    cart.cart_items.each do |cart_item|
      order.order_items.new(
        item_id: cart_item.item_id,
        price: cart_item.item.price,
        quantity: cart_item.quantity
      )
    end

    order.save ? order : nil
  end
end
