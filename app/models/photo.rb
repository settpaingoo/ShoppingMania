class Photo < ActiveRecord::Base
  attr_accessible :item_id, :image

  has_attached_file :image, styles: { full: "600x600#", thumb: "100x100#" }

  validates :item, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  belongs_to :item
end
