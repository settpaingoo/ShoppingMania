class Item < ActiveRecord::Base
  attr_accessible :name, :price, :stock, :brand_id, :category_id, :description

  validates :name, :price, :stock, :brand, :category, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :brand
  belongs_to :category
  has_many :photos

  def self.filter(items, options)

    items = Item.filter_by_price(items, options[:price])
    items = Item.filter_by_brand(items, options[:brand_ids])

    items
  end

  def self.filter_by_price(items, price_options)
    return items if price_options.nil?

    min_price = price_options[:min]
    max_price = price_options[:max]
    items = items.where("price >= ?", min_price) if min_price > 0
    items = items.where("price <= ?", max_price) if max_price > 0

    items
  end

  def self.filter_by_brand(items, brand_ids)
    return items if (brand_ids.nil? || brand_ids.empty?)

    items.where("brand_id IN (?)", brand_ids)
  end

  def add_stock(quantity)
    return false if quantity < 1

    self.stock += quantity
    self.save
  end

  def remove_stock(quantity)
    return false if quantity < 1 || quantity > stock

    self.stock -= quantity
    self.save
  end
end
