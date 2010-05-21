class Customer < ActiveRecord::Base
  # Legacy Database
  set_table_name :customers
  set_primary_key :customers_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
