class Brand < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true

  has_many :items, inverse_of: :brand
end
