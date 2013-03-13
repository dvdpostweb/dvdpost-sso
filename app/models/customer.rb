class Customer < ActiveRecord::Base
  # Legacy Database
  set_table_name :customers
  set_primary_key :customers_id

  alias_attribute :email, :customers_email_address
  #alias_attribute :password, :customers_password
  validates_presence_of :customers_email_address
  validates_format_of   :customers_email_address, :with  => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, :allow_blank => true, :if => :email_changed?
  validates_uniqueness_of :customers_email_address, :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_presence_of     :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_length_of       :password, :within => 6..20, :allow_blank => true
  devise :database_authenticatable, :token_authenticatable, :rememberable, :registerable #, :recoverable

  before_create :set_defaults

  # Setup accessible (or protected) attributes for your model
  attr_accessor :promotion, :newsletter, :p_id
  attr_accessible :customers_email_address, :password, :password_confirmation, :promotion, :newsletter, :p_id, :site, :remember_me
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

  def set_defaults
    if self.newsletter == "1"
      self.customers_newsletter = 1
      self.customers_newsletterpartner = 1
      self.marketing_ok = 'YES'
    else
      self.customers_newsletter = 0
      self.customers_newsletterpartner = 0
      self.marketing_ok = 'NO'
    end
    activation = Activation.available.not_used.by_name(self.promotion).first
    if activation
      self.activation_discount_code_id = activation.to_param
      self.activation_discount_code_type = 'A'
      next_discount_code = activation.next_discount > 0 ? activation.next_discount : 0
      self.customers_next_discount_code = next_discount_code
      self.customers_registration_step = 21
      self.customers_abo_type = activation.activation_products_id
      self.customers_next_abo_type = activation.next_abo_type > 0 ? activation.next_abo_type : activation.activation_products_id
    else  
      discount = Discount.available.by_name(self.promotion).first
      unless discount
        discount = Discount.find(298)
      end
      self.activation_discount_code_id = discount.to_param
      self.activation_discount_code_type = 'D'
      next_discount_code = discount.next_discount > 0 ? discount.next_discount : 0
      self.customers_next_discount_code = next_discount_code
      self.customers_registration_step = discount.step
      self.customers_abo_type = discount.listing_products_allowed
      self.customers_next_abo_type = discount.next_abo_type > 0 ? discount.next_abo_type : discount.listing_products_allowed
    end
    self.customers_info_date_account_created = Time.now
    self.customers_password = Digest::MD5.hexdigest(password)
    if self.p_id &&  self.p_id > 0
      Sponsor.create(:customers_id => self.p_id, :date => Time.now, :email => self.email, :language_id => I18n.locale)
    end
  end
  
  def password_required?
    !password.nil? || !password_confirmation.nil?
  end
end
