class Activation < ActiveRecord::Base
  set_table_name :activation_code
  set_primary_key :activation_id

  alias_attribute :name, :activation_code
  alias_attribute :expire_at, :activation_code_validto_date

  scope :by_name, lambda {|name| {:conditions => {:activation_code => name}}}
  scope :available, lambda {{:conditions => ['activation_code_validto_date > ? or activation_code_validto_date is null', Time.now.to_s(:db)]}}
  scope :not_used, :conditions => 'customers_id = 0'
end