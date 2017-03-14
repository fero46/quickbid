# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140514135709) do

  create_table "auction_configuration_memberships", :force => true do |t|
    t.integer  "product_id"
    t.integer  "auction_configuration_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "auction_configuration_memberships", ["auction_configuration_id"], :name => "acm_ac"
  add_index "auction_configuration_memberships", ["product_id", "auction_configuration_id"], :name => "acm_pr_ac", :unique => true
  add_index "auction_configuration_memberships", ["product_id"], :name => "acm_pr"

  create_table "auction_configurations", :force => true do |t|
    t.string   "name"
    t.string   "day_in_week"
    t.string   "day_part"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "auction_configurations", ["day_in_week"], :name => "index_auction_configurations_on_day_in_week"
  add_index "auction_configurations", ["name"], :name => "index_auction_configurations_on_name"

  create_table "auctions", :force => true do |t|
    t.datetime "start",                              :null => false
    t.datetime "end",                                :null => false
    t.string   "state",                              :null => false
    t.integer  "product_id",                         :null => false
    t.integer  "required_bids",   :default => 0,     :null => false
    t.integer  "bids",            :default => 0,     :null => false
    t.integer  "intern_bids",     :default => 0,     :null => false
    t.integer  "timer"
    t.integer  "category_id"
    t.integer  "visits",          :default => 0,     :null => false
    t.string   "accounting_code",                    :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "checked",         :default => false
    t.integer  "winner"
    t.integer  "bot_bidder_1",    :default => 0
    t.integer  "bot_bidder_2",    :default => 0
    t.integer  "last_bidder_bot", :default => 0
    t.boolean  "deactivate_bots", :default => false
  end

  add_index "auctions", ["accounting_code"], :name => "index_auctions_on_accounting_code", :unique => true
  add_index "auctions", ["category_id"], :name => "index_auctions_on_category_id"
  add_index "auctions", ["checked"], :name => "index_auctions_on_checked"
  add_index "auctions", ["end"], :name => "index_auctions_on_end"
  add_index "auctions", ["product_id"], :name => "index_auctions_on_product_id"
  add_index "auctions", ["start"], :name => "index_auctions_on_start"
  add_index "auctions", ["state"], :name => "index_auctions_on_state"
  add_index "auctions", ["winner"], :name => "index_auctions_on_winner"

  create_table "bid_histories", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bid_histories", ["auction_id"], :name => "index_bid_histories_on_auction_id"
  add_index "bid_histories", ["user_id"], :name => "index_bid_histories_on_user_id"

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.string  "image"
    t.integer "category_id"
    t.integer "order_value"
    t.boolean "is_leaf"
  end

  add_index "categories", ["category_id"], :name => "index_categories_on_category_id"
  add_index "categories", ["order_value"], :name => "index_categories_on_order_value"

  create_table "dayli_payments", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "value",      :precision => 10, :scale => 2
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "dayli_payments", ["created_at"], :name => "index_dayli_payments_on_created_at"
  add_index "dayli_payments", ["user_id"], :name => "index_dayli_payments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "luckylosers", :force => true do |t|
    t.text     "ranking"
    t.date     "startday"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "luckylosers", ["startday"], :name => "index_luckylosers_on_startday", :unique => true

  create_table "order_variations", :force => true do |t|
    t.integer  "order_id"
    t.string   "group_name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "order_variations", ["order_id"], :name => "index_order_variations_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "lastname"
    t.string   "street"
    t.string   "streetnumber"
    t.string   "zipcode"
    t.string   "city"
    t.text     "note"
    t.boolean  "correct"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "orders", ["auction_id"], :name => "index_orders_on_auction_id", :unique => true
  add_index "orders", ["correct"], :name => "index_orders_on_correct"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["name"], :name => "index_pages_on_name", :unique => true

  create_table "partners", :force => true do |t|
    t.string   "fullname"
    t.string   "firma"
    t.text     "adresse"
    t.string   "telefon"
    t.string   "email"
    t.text     "notiz"
    t.string   "kontoinhaber"
    t.string   "bank"
    t.string   "iban"
    t.string   "bic"
    t.string   "refcode"
    t.string   "partner_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "partners", ["refcode"], :name => "index_partners_on_refcode", :unique => true

  create_table "payments", :force => true do |t|
    t.text     "params"
    t.integer  "user_id"
    t.string   "status"
    t.string   "transaction_id"
    t.string   "action"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "payments", ["transaction_id"], :name => "index_payments_on_transaction_id"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "product_variations", :force => true do |t|
    t.integer  "product_id"
    t.integer  "variation_group_id"
    t.string   "value"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "product_variations", ["product_id"], :name => "index_product_variations_on_product_id"
  add_index "product_variations", ["variation_group_id"], :name => "index_product_variations_on_variation_group_id"

  create_table "products", :force => true do |t|
    t.string   "brand"
    t.string   "short_description"
    t.text     "description"
    t.decimal  "price",             :precision => 10, :scale => 2
    t.string   "remote_id"
    t.string   "online_shop"
    t.string   "shop_url"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.decimal  "shipment_price",    :precision => 10, :scale => 2
    t.integer  "category_id"
    t.boolean  "activated",                                        :default => false
  end

  add_index "products", ["activated"], :name => "index_products_on_activated"
  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["remote_id", "online_shop"], :name => "index_products_on_remote_id_and_online_shop"
  add_index "products", ["remote_id"], :name => "index_products_on_remote_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                       :default => "",     :null => false
    t.string   "encrypted_password",          :default => "",     :null => false
    t.string   "role",                        :default => "USER", :null => false
    t.integer  "credit",                      :default => 0,      :null => false
    t.boolean  "bot",                         :default => false
    t.integer  "paid_bids",                   :default => 0
    t.integer  "free_bids",                   :default => 3
    t.integer  "bid_counter",                 :default => 0
    t.string   "invite_code",                                     :null => false
    t.string   "inviter_reference"
    t.string   "invite_code_checked",         :default => "1"
    t.integer  "invite_counter",              :default => 0,      :null => false
    t.string   "accounting_code",                                 :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.integer  "last_auction"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.date     "last_present_day"
    t.integer  "last_second_autobid_counter", :default => 0
    t.integer  "last_first_autobid_counter",  :default => 0
    t.integer  "last_first_auto_bid",         :default => 0
    t.integer  "last_second_auto_bid",        :default => 0
    t.boolean  "first_sale",                  :default => true
    t.string   "refered_from",                :default => ""
  end

  add_index "users", ["accounting_code"], :name => "index_users_on_accounting_code", :unique => true
  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["bot"], :name => "index_users_on_bot"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invite_code"], :name => "index_users_on_invite_code", :unique => true
  add_index "users", ["last_auction"], :name => "index_users_on_last_auction"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "variation_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
