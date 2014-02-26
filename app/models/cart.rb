class Cart < ActiveRecord::Base
  attr_accessible :user_id

  validates :user, presence: true
  belongs_to :user
  has_many :cart_items, dependent: :destroy, inverse_of: :cart

  def self.build_temporary_cart(cart_item_params)
    cart = Cart.new
    return cart if cart_item_params.nil? || cart_item_params.empty?

    cart_item_params.each do |item_id, quantity|
      cart_item = CartItem.new(item_id: item_id, quantity: quantity.to_i)
      cart.cart_items << cart_item
    end

    cart
  end

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
    if self.persisted?
      cart_items.includes(:item).map(&:subtotal).inject(:+)
    else
      item_ids = cart_items.map(&:item_id)
      items_hash = {}
      Item.find(item_ids).each { |item| items_hash[item.id] = item }

      cart_items.each do |cart_item|
        cart_item.item = items_hash[cart_item.item_id]
      end
      cart_items.map(&:subtotal).inject(:+)
    end
  end

  def combine(another_cart)
    return self if self.user_id && another_cart.user_id

    begin
      Cart.transaction do
        self.user_id ||= another_cart.user_id
        self.save!

        another_cart.cart_items.each do |cart_item|
          self.add_item(cart_item.item_id, cart_item.quantity)
        end

        another_cart.destroy
      end
    ensure
      return self
    end
  end

end
