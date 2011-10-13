class AddVerificationCodeToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :verification_code, :string
  end

  def self.down
    remove_column :customers, :verification_code
  end
end
