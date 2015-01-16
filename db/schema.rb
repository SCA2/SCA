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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150116024547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state_code"
    t.string   "post_code"
    t.string   "country"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "address_type"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "purchased_at"
  end

  create_table "faqs", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_weight"
    t.integer  "faqs_category_id"
  end

  add_index "faqs", ["faqs_category_id"], name: "index_faqs_on_faqs_category_id", using: :btree

  create_table "faqs_categories", force: true do |t|
    t.string  "category_name"
    t.integer "category_weight"
  end

  create_table "features", force: true do |t|
    t.string   "caption"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "sort_order"
  end

  add_index "features", ["product_id", "sort_order"], name: "index_features_on_product_id_and_sort_order", using: :btree

  create_table "line_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",       default: 1
    t.integer  "extended_price"
    t.integer  "option_id"
    t.boolean  "remove",         default: false
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "options", force: true do |t|
    t.string   "model"
    t.string   "description"
    t.integer  "price"
    t.string   "upc"
    t.integer  "shipping_weight"
    t.integer  "kit_stock"
    t.integer  "part_stock"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "discount"
    t.integer  "shipping_volume"
    t.integer  "shipping_length"
    t.integer  "shipping_width"
    t.integer  "shipping_height"
    t.integer  "assembled_stock"
    t.integer  "partial_stock"
  end

  create_table "orders", force: true do |t|
    t.integer  "cart_id"
    t.string   "email"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.string   "shipping_method"
    t.integer  "shipping_cost"
    t.integer  "sales_tax"
    t.string   "use_billing"
  end

  create_table "products", force: true do |t|
    t.string   "model"
    t.text     "short_description"
    t.text     "long_description"
    t.string   "image_1"
    t.string   "image_2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.integer  "category_sort_order"
    t.integer  "model_sort_order"
    t.text     "notes"
    t.string   "bom"
    t.string   "schematic"
    t.string   "assembly"
    t.string   "specifications"
  end

  create_table "slider_images", force: true do |t|
    t.string   "name"
    t.text     "caption"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product_url"
    t.integer  "sort_order"
  end

  create_table "transactions", force: true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  default: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "contact_sales"
    t.boolean  "contact_news"
    t.boolean  "contact_updates"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
