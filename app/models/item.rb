class Item < ActiveRecord::Base
  include PgSearch
  pg_search_scope(
    :search_by_name,
    against: :name,
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english"
      }
    }
  )

  attr_accessible :name, :price, :stock, :brand_id, :category_id, :description

  validates :name, :price, :stock, :brand, :category, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :brand
  belongs_to :category
  has_many :photos, dependent: :destroy, inverse_of: :item
  has_many :reviews
  has_many :order_items

  def self.filter(options)
    items = Item.includes(:photos)
              .joins("LEFT OUTER JOIN reviews ON items.id = reviews.item_id")
              .group("items.id")
              .select("items.*, AVG(reviews.rating) AS rating")

    return items if (options.nil? || options.empty?)

    items = Item.filter_by_price(items, options[:price]) if options[:price]
    items = Item.filter_by_brand(items, options[:brand_ids]) if options[:brand_ids]
    items = Item.filter_by_category(items, options[:category_ids]) if options[:category_ids]
    items = Item.filter_by_rating(items, options[:rating]) if options[:rating]
    items = items.search_by_name(options[:name]) if options[:name]

    items
  end

  def self.filter_by_price(items, options)
    min_price = options[:min] || 0
    max_price = options[:max] || 0

    items = items.where("items.price >= ?", min_price) if min_price > 0
    items = items.where("items.price <= ?", max_price) if max_price > 0

    items
  end

  def self.filter_by_brand(items, brand_ids)
    return items if brand_ids.empty?

    items.where("brand_id IN (?)", brand_ids)
  end

  def self.filter_by_category(items, category_ids)
    return items if category_ids.empty?

    items.where("category_id IN (?)", category_ids)
  end

  def self.filter_by_rating(items, min_rating)
    return items if min_rating > 5

    items.having("AVG(reviews.rating) >= ?", min_rating)
  end

  def self.sort(items, criterium)
    case criterium
    when "price_asc"
      items.order("price")
    when "price_desc"
      items.order("price").reverse_order
    when "recent"
      items.order("items.created_at").reverse_order
    when "rating"
      items.order("AVG(reviews.rating) DESC NULLS LAST")
    when "popularity"
      items.joins("LEFT OUTER JOIN order_items ON items.id = order_items.item_id")
        .group("items.id")
        .order("SUM(order_items.quantity) DESC NULLS LAST")
    else
      items
    end
  end

  def thumbnail
    photos.first.image.url(:thumb)
  end

  def average_rating
    # Rails.cache.fetch("average_rating_item#{self.id}", :expires_in => 1.hour) do
      force_average_rating
    # end
  end

  def force_average_rating
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
