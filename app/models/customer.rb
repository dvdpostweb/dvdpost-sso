class Customer < ActiveRecord::Base
  # Legacy Database
  set_table_name :customers
  set_primary_key :customers_id

  alias_attribute :email, :customers_email_address
  alias_attribute :password, :customers_password
  

  devise :database_authenticatable, :validatable, :token_authenticatable, :rememberable #, :recoverable, :registerable

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

  def update_tokens!
    destroy_attribute :verification_code
    reset_access_token! if access_token_expired?
    reset_refresh_token! if refresh_token_expired? && remember_token?
    true
  end

  def reset_access_token!
    reset_authentication_token!
    expiry_date = remember_token? ? 2.weeks.from_now : 1.day.from_now
    update_attribute(:access_token_expires_at, expiry_date)
  end

  def reset_refresh_token!
    update_attribute(:refresh_token, Digest::SHA1.hexdigest("dvdpost_secret_for_#{email}_at_#{Time.now}_which_expires_at_#{10.years.from_now}"))
    update_attribute(:refresh_token_expires_at, 10.years.from_now) # 10 years as in "unlimited" (yes I know, it's nasty)
  end

  def valid_tokens?
    authentication_token? && !access_token_expired?
  end

  def access_token_expired?
     access_token_expires_at.blank? || (access_token_expires_at < Date.today)
  end

  def refresh_token_expired?
    refresh_token_expires_at.blank? || (refresh_token_expires_at < Date.today)
  end

  def access_token_expires_in
    refresh_token_expires_at? ? (access_token_expires_at.to_time.to_i - Time.now.to_i) : 0
  end

  def destroy_tokens!
    destroy_attribute :verification_code
    destroy_attribute :authentication_token
    destroy_attribute :refresh_token
    destroy_attribute :refresh_token_expires_at
    destroy_attribute :access_token_expires_at
    destroy_attribute :remember_token
    destroy_attribute :remember_created_at
  end

  private
  def destroy_attribute(attr)
    update_attribute(attr, nil)
  end
end
