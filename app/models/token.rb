class Token < ActiveRecord::Base
  attr_accessible :user_id

  validates :user, :token_string, presence: true

  before_validation :ensure_token

  belongs_to :user

  def self.generate_random_token
    SecureRandom::urlsafe_base64(16);
  end

  def ensure_token
    self.token_string = Token.generate_random_token
  end
end
