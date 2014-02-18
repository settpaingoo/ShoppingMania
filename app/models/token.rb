class Token < ActiveRecord::Base
  attr_accessible :user_id

  validates :user, :token_string, presence: true

  before_validation :ensure_token

  belongs_to :user, inverse_of: :tokens

  def self.generate_random_token
    SecureRandom::urlsafe_base64(16);
  end

  def ensure_token
    loop do
      token = Token.generate_random_token

      #probably don't need this
      unless Token.exists?(['token_string = ?', token])
        self.token_string = token
        break
      end
    end
  end
end
