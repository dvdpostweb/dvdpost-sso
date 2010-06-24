# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100621131413) do
  create_table "customers", :primary_key => "customers_id", :force => true do |t|
    t.string   "customers_email_address"
    t.string   "customers_password"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.string   "authentication_token"
    t.string   "verification_code"
    t.string   "refresh_token"
    t.date     "refresh_token_expires_at"
    t.date     "access_token_expires_at"
  end
end
