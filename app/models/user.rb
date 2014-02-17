class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  validates :first_name, :last_name, :email, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  has_many :tokens

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email);
    return nil if user.nil?

    user.authenticate(password) ? user : nil
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
