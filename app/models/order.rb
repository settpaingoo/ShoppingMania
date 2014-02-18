class Order < ActiveRecord::Base
  attr_accessible :user_id

  validates :user, presence: true

  belongs_to :user, inverse_of: :orders
  has_many :order_items, inverse_of: :order
  has_many :items, through: :order_items

  #make_sure to avoid (n+1) queries
  def add_items(cart_items)
    cart_items.each do |cart_item|
      self.order_items.new(
        item_id: cart_item.item_id,
        price: cart_item.item.price,
        quantity: cart_item.quantity
      )
    end

    self.save
  end
end
