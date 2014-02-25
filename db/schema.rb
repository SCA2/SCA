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

ActiveRecord::Schema.define(version: 20140225063440) do

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
    t.text     "short_description"
    t.text     "long_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "caption_sort_order"
  end

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
    t.integer  "category_weight"
    t.integer  "model_weight"
    t.text     "notes"
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
