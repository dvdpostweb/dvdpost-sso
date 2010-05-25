class Customer < ActiveRecord::Base
  # Legacy Database
  set_table_name :customers
  set_primary_key :customers_id

  alias_attribute :email, :customers_email_address
  alias_attribute :password, :customers_password

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :customers_email_address, :password, :password_confirmation

  def valid_password?(provided_password)
    hash_password, salt = customers_password.split(':')
    result = Digest::MD5.hexdigest("#{salt}#{provided_password}")
    return hash_password == result
  end
end
