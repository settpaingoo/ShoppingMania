# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ShoppingMania::Application.initialize!

if Rails.env.production?

elsif Rails.env.development?
  ActionMailer::Base.delivery_method = :letter_opener
end