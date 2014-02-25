class WishlistItem < ActiveRecord::Base
  attr_accessible :wishlist_id, :item_id

  validates :wishlist, :item, presence: true
  validates :item_id, uniqueness: { scope: :wishlist_id }

  belongs_to :wishlist
  belongs_to :item, include: :photos
end
