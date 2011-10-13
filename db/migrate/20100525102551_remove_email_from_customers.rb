class RemoveEmailFromCustomers < ActiveRecord::Migration
  def self.up
    remove_column :customers, :email
  end

  def self.down
    add_column :customers, :email, :string
  end
end
