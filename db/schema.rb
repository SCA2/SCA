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

ActiveRecord::Schema.define(version: 20140303063238) do

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", force: true do |t|
    t.string   "category"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_weight"
    t.integer  "category_weight"
  end

  create_table "features", force: true do |t|
    t.string   "model"
    t.string   "caption"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "sort_order"
  end

  add_index "features", ["product_id", "sort_order"], name: "index_features_on_product_id_and_sort_order"

  create_table "line_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",       default: 1
    t.integer  "extended_price"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id"
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id"

  create_table "products", force: true do |t|
    t.string   "model"
    t.text     "short_description"
    t.text     "long_description"
    t.string   "upc"
    t.string   "image_1"
    t.string   "image_2"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.integer  "category_sort_order"
    t.integer  "model_sort_order"
    t.text     "notes"
    t.string   "kit"
    t.string   "option"
    t.integer  "part_stock"
    t.integer  "kit_stock"
    t.integer  "finished_stock"
  end

  create_table "slider_images", force: true do |t|
    t.string   "name"
    t.text     "caption"
    t.string   "url"
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
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
