module Rememberable
  def serialize_from_cookie(id, remember_token)
    conditions = { :customers_id => id, :remember_token => remember_token }
    record = find(:first, :conditions => conditions)
    record if record && !record.remember_expired?
  end
end
