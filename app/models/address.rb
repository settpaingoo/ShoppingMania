class Address < ActiveRecord::Base
  STATES = %w(AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY)

  attr_accessible :user_id, :street, :city, :state, :zipcode
  validates :street, :city, :state, :zipcode, presence: true
  validates :state, inclusion: { in: STATES }
  validates :zipcode, format: { with: /\A\d{5}(-\d{4})?\Z/i }

  belongs_to :user
  has_many :orders
end
