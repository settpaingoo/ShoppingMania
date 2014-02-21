class Item < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_name, against: :name #redo later

  attr_accessible :name, :price, :stock, :brand_id, :category_id, :description

  validates :name, :price, :stock, :brand, :category, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :brand
  belongs_to :category
  has_many :photos, dependent: :destroy, inverse_of: :item
  has_many :reviews

  def self.filter(options)
    items = Item.includes(:photos)
    return items if (options.nil? || options.empty?)

    items = Item.filter_by_price(items, options[:price]) if options[:price]
    items = Item.filter_by_brand(items, options[:brand_ids]) if options[:brand_ids]
    items = Item.filter_by_category(items, options[:category_ids]) if options[:category_ids]
    items = items.search_by_name(options[:name]) if options[:name]

    items
  end

  def self.filter_by_price(items, options)
    min_price = options[:min] || 0
    max_price = options[:max] || 0

    items = items.where("price >= ?", min_price) if min_price > 0
    items = items.where("price <= ?", max_price) if max_price > 0

    items
  end

  def self.filter_by_brand(items, brand_ids)
    return items if (brand_ids.nil? || brand_ids.empty?)

    items.where("brand_id IN (?)", brand_ids)
  end

  def self.filter_by_category(items, category_ids)
    return items if (category_ids.nil? || category_ids.empty?)

    items.where("category_id IN (?)", category_ids)
  end

  def self.sort(items, criterium)
    case criterium
    when "price_asc"
      items.order("price asc")
    when "price_desc"
      items.order("price desc")
    else
      items
    end
  end

  def average_rating
    #cache
    self.reviews.average("rating").to_f.round(1)
  end

  def add_stock(quantity)
    raise "cannot add stock" if quantity < 1

    self.stock += quantity
    self.save!
  end

  def remove_stock(quantity)
    raise "cannot remove stock" if quantity < 1 || quantity > stock

    self.stock -= quantity
    self.save!
  end
end
