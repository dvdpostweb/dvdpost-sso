module Helpers
  def generate_unique_email
    @@email_count ||= 0
    @@email_count += 1
    "test#{@@email_count}@email.com"
  end

  def valid_attributes(attributes={})
    { :username => "usertest",
      :email => generate_unique_email,
      :password => '123456',
      :password_confirmation => '123456' }.update(attributes)
  end

  def new_customer(attributes={})
    Customer.new(valid_attributes(attributes))
  end

  def create_customer(attributes={})
    Customer.create!(valid_attributes(attributes))
  end
end
