class Discount < ActiveRecord::Base
  set_table_name :discount_code
  set_primary_key :discount_code_id
  
  alias_attribute :name,:discount_code
  alias_attribute :expire_at, :discount_validityto
  alias_attribute :step, :goto_step
  
  scope :by_name, lambda {|name| {:conditions => {:discount_code => name}}}
  scope :available, lambda {{:conditions => ['discount_validityto > ? or discount_validityto is null', Time.now.to_s(:db)]}}
  
end