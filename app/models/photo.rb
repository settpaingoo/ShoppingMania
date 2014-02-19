class Photo < ActiveRecord::Base
  attr_accessible :item_id, :image

  has_attached_file :image, styles: { full: "1000x1000", thumb: "200x200" }

  belongs_to :item
end
