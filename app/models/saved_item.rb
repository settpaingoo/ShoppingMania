class SavedItem < ActiveRecord::Base
  attr_accessible :cart_id, :item_id

  validates :cart, :item, presence: true
  validates :item_id, uniqueness: { scope: :cart_id }

  belongs_to :item
  belongs_to :cart
end
