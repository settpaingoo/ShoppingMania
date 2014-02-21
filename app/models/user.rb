class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :uid, :first_name, :last_name, :email, :password, :password_confirmation

  validates :first_name, :last_name, :email, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  has_many :tokens
  has_one :cart
  has_many :orders, include: :order_items, order: "created_at DESC"
  has_many :wishlists, include: :wishlist_items

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email);

    (user && user.authenticate(password)) ? user : nil
  end

  def self.create_from_fb_data(params)
    user = User.find_by_email(params[:info][:email])
    if user
      user.uid = params[:uid]
    else
      user = User.create(
        uid: params[:uid],
        first_name: params[:info][:first_name],
        last_name: params[:info][:last_name],
        email: params[:info][:email],
        password: SecureRandom::urlsafe_base64(8)
      )
    end

    user
  end

  def activated?
    activated
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    is_admin
  end
end
