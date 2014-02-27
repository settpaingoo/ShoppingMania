class Cart < ActiveRecord::Base
  attr_accessible :user_id

  validates :user, presence: true
  belongs_to :user
  has_many :cart_items, dependent: :destroy, inverse_of: :cart
  has_many :saved_items, dependent: :destroy, inverse_of: :cart

  def self.build_temporary_cart(cart_item_params, saved_item_ids)
    cart = Cart.new

    cart_item_params.try(:each) do |item_id, quantity|
      cart_item = CartItem.new(item_id: item_id, quantity: quantity.to_i)
      cart.cart_items << cart_item
    end

    saved_item_ids.try(:each) do |item_id|
      saved_item = SavedItem.new(item_id: item_id)
      cart.saved_items << saved_item
    end

    cart
  end

  def add_item(item_id, quantity)
    raise "must add a positive quantity" unless quantity > 0

    cart_item = CartItem.find_by_cart_id_and_item_id(id, item_id)

    if cart_item
      new_quantity = cart_item.quantity + quantity
      cart_item.update_attributes(quantity: new_quantity)
    else
      cart_items.create(item_id: item_id, quantity: quantity)
      saved_item = SavedItem.find_by_cart_id_and_item_id(id, item_id)
      saved_item.try(:destroy)
    end
  end

  def save_item(item_id, remove_from_cart = true)
    saved_item = SavedItem.find_by_cart_id_and_item_id(id, item_id)
    saved_items.create(item_id: item_id) unless saved_item
    if remove_from_cart
      cart_item = CartItem.find_by_cart_id_and_item_id(id, item_id)
      cart_item.try(:destroy)
    end
  end

  def total
    if persisted?
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
    return self if user_id && another_cart.user_id

    self.user_id ||= another_cart.user_id
    save!

    another_cart.cart_items.each do |cart_item|
      add_item(cart_item.item_id, cart_item.quantity)
    end

    another_cart.saved_items.each do |saved_item|
      save_item(saved_item.item_id, false)
    end

    another_cart.destroy

    self
  end

end
