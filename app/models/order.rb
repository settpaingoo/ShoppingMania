class Order < ActiveRecord::Base
  attr_accessible :user_id

  validates :user, presence: true

  belongs_to :user
  has_many :order_items, inverse_of: :order, include: :item

  #make_sure to avoid (n+1) queries
  #ask TA
  def add_items(cart)
    cart.cart_items.each do |cart_item|
      self.order_items.new(
        item_id: cart_item.item_id,
        price: cart_item.item.price,
        quantity: cart_item.quantity
      )
    end

    self.save
  end
end
