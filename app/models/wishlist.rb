class Wishlist < ActiveRecord::Base
  attr_accessible :user_id, :name

  validates :user, :name, presence: true

  belongs_to :user
  has_many :wishlist_items, dependent: :destroy, include: :item
end
