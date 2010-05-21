class DeviseCreateCustomers < ActiveRecord::Migration
  def self.up
    if Rails.env.test?
      create_table(:customers, :primary_key => :customers_id)
    end
    change_table(:customers) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.token_authenticatable
    end

    add_index :customers, :reset_password_token, :unique => true
    add_index :customers, :authentication_token, :unique => true
  end

  def self.down
    if Rails.env.test?
      drop_table :customers
    else
      change_table(:customers) do |t|
        t.remove :email
        t.remove :encrypted_password
        t.remove :password_salt
        t.remove :reset_password_token
        t.remove :remember_token
        t.remove :remember_created_at
        t.remove :authentication_token
      end
      remove_index :customers, :reset_password_token, :unique => true
      remove_index :customers, :authentication_token, :unique => true
    end
  end
end
