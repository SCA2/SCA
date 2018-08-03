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

ActiveRecord::Schema.define(version: 20180803225735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "address_1", limit: 255
    t.string "address_2", limit: 255
    t.string "city", limit: 255
    t.string "state_code", limit: 255
    t.string "post_code", limit: 255
    t.string "country", limit: 255
    t.string "telephone", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "addressable_id"
    t.string "addressable_type", limit: 255
    t.string "address_type", limit: 255
    t.index ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type"
  end

  create_table "bom_items", id: :serial, force: :cascade do |t|
    t.integer "quantity"
    t.string "reference"
    t.integer "bom_id"
    t.integer "component_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boms", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "option_id"
  end

  create_table "carts", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "purchased_at"
    t.string "invoice_token"
    t.datetime "invoice_sent_at"
    t.datetime "invoice_retrieved_at"
    t.string "invoice_email"
    t.string "invoice_name"
    t.index ["invoice_token"], name: "index_carts_on_invoice_token"
  end

  create_table "components", id: :serial, force: :cascade do |t|
    t.string "value"
    t.string "marking"
    t.string "description"
    t.string "mfr"
    t.string "vendor"
    t.string "mfr_part_number"
    t.string "vendor_part_number"
    t.integer "stock"
    t.integer "lead_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "question_weight"
    t.integer "faqs_category_id"
    t.index ["faqs_category_id"], name: "index_faqs_on_faqs_category_id"
  end

  create_table "faqs_categories", id: :serial, force: :cascade do |t|
    t.string "category_name", limit: 255
    t.integer "category_weight"
  end

  create_table "features", id: :serial, force: :cascade do |t|
    t.string "caption", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "product_id"
    t.integer "sort_order"
    t.index ["product_id", "sort_order"], name: "index_features_on_product_id_and_sort_order"
  end

  create_table "line_items", id: :serial, force: :cascade do |t|
    t.integer "cart_id"
    t.integer "option_id"
    t.bigint "component_id"
    t.bigint "misc_id"
    t.integer "quantity", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
  end

  create_table "options", id: :serial, force: :cascade do |t|
    t.string "model", limit: 255
    t.string "description", limit: 255
    t.integer "price"
    t.string "upc", limit: 255
    t.integer "shipping_weight"
    t.integer "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "discount"
    t.integer "shipping_length"
    t.integer "shipping_width"
    t.integer "shipping_height"
    t.integer "assembled_stock", default: 0
    t.boolean "active", default: true, null: false
    t.bigint "product_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "cart_id"
    t.string "email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "express_token", limit: 255
    t.string "express_payer_id", limit: 255
    t.string "shipping_method", limit: 255
    t.integer "shipping_cost", default: 0
    t.integer "sales_tax", default: 0
    t.string "use_billing", limit: 255
    t.string "ip_address"
    t.string "stripe_token"
    t.boolean "confirmed", default: false
    t.index ["cart_id"], name: "index_orders_on_cart_id"
  end

  create_table "product_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "model", limit: 255
    t.text "short_description"
    t.text "long_description"
    t.string "image_1", limit: 255
    t.string "image_2", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "sort_order"
    t.text "notes"
    t.string "bom", limit: 255
    t.string "schematic", limit: 255
    t.string "assembly", limit: 255
    t.string "specifications", limit: 255
    t.boolean "active", default: true, null: false
    t.integer "{:foreign_key=>true}_id"
    t.integer "partial_stock", default: 0
    t.integer "kit_stock", default: 0
    t.integer "product_category_id"
    t.index ["model"], name: "index_products_on_model"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
  end

  create_table "slider_images", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "caption"
    t.string "image_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "product_url", limit: 255
    t.integer "sort_order"
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.string "action", limit: 255
    t.integer "amount"
    t.boolean "success"
    t.string "authorization", limit: 255
    t.string "message", limit: 255
    t.text "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "tracking_number"
    t.datetime "shipped_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest", limit: 255
    t.string "remember_token", limit: 255
    t.boolean "admin", default: false
    t.string "password_reset_token", limit: 255
    t.datetime "password_reset_sent_at"
    t.boolean "contact_sales"
    t.boolean "contact_news"
    t.boolean "contact_updates"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "line_items", "carts", name: "line_items_carts_fk", on_delete: :cascade
  add_foreign_key "line_items", "options", name: "line_items_options_fk", on_delete: :restrict
  add_foreign_key "orders", "carts", name: "orders_carts_fk", on_delete: :restrict
  add_foreign_key "transactions", "orders", name: "transactions_orders_fk", on_delete: :cascade
end
