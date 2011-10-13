class AddRefreshTokenAndExpireDatesToCustomer < ActiveRecord::Migration
  def self.up
    change_table :customers do |t|
      t.string :refresh_token
      t.date :refresh_token_expires_at
      t.date :access_token_expires_at
    end
  end

  def self.down
    change_table :customers do |t|
      t.remove :refresh_token
      t.remove :refresh_token_expires_at
      t.remove :access_token_expires_at
    end
  end
end
