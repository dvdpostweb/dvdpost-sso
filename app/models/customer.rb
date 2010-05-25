class Customer < ActiveRecord::Base
  # Legacy Database
  set_table_name :customers
  set_primary_key :customers_id

  alias_attribute :email, :customers_email_address

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :customers_email_address, :password, :password_confirmation
end
