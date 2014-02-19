class Review < ActiveRecord::Base
  attr_accessible :item_id, :user_id, :rating, :title, :body

  validates :item, :user, :rating, :title, :body, presence: true
  validates :rating, numericality:
    { only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5 }

  belongs_to :item
  belongs_to :user
end
