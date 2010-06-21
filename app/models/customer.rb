class Customer < ActiveRecord::Base
  # Legacy Database
  set_table_name :customers
  set_primary_key :customers_id

  alias_attribute :email, :customers_email_address
  alias_attribute :password, :customers_password

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :token_authenticatable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :customers_email_address, :password, :password_confirmation

  def valid_password?(provided_password)
    hash_password, salt = customers_password.split(':')
    result = Digest::MD5.hexdigest("#{salt}#{provided_password}")
    return hash_password == result
  end

  def generate_verification_code!
    update_attribute(:verification_code, Digest::SHA1.hexdigest("dvdpost_secret_for_#{email}_at_#{Time.now}"))
    verification_code
  end

  def generate_tokens!
    reset_access_token! and reset_refresh_token!
  end

  def update_tokens!
    reset_access_token! if access_token_expired?
    reset_refresh_token! if refresh_token_expired?
    true
  end

  def reset_access_token!
    reset_authentication_token!
    update_attribute(:access_token_expires_at, 2.weeks.from_now) if remember_token?
  end

  def reset_refresh_token!
    update_attribute(:refresh_token, Digest::SHA1.hexdigest("dvdpost_secret_for_#{email}_at_#{Time.now}_which_expires_at_#{1.month.from_now}"))
    update_attribute(:refresh_token_expires_at, 1.month.from_now) if remember_token?
  end

  def access_token_expired?
     access_token_expires_at.blank? or (access_token_expires_at < Date.today)
  end

  def refresh_token_expired?
    refresh_token_expires_at.blank? or (refresh_token_expires_at < Date.today)
  end

  def access_token_expires_in
    refresh_token_expires_at? ? (access_token_expires_at.to_time.to_i - Time.now.to_i) : 0
  end

  def destroy_tokens!
    update_attribute(:verification_code, nil)
    update_attribute(:authentication_token, nil)
    update_attribute(:refresh_token, nil)
    update_attribute(:refresh_token_expires_at, nil)
    update_attribute(:access_token_expires_at, nil)
  end
end
