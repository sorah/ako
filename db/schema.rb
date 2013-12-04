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

ActiveRecord::Schema.define(version: 20131204111738) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.text     "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", force: true do |t|
    t.integer  "amount"
    t.string   "name",       default: ""
    t.text     "meta"
    t.datetime "paid_at"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "budget",     default: 0
    t.integer  "order",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fixed",      default: false
    t.string   "icon"
  end

  create_table "expenses", force: true do |t|
    t.integer  "amount"
    t.text     "comment",         default: ""
    t.text     "meta"
    t.datetime "paid_at"
    t.integer  "place_id"
    t.integer  "sub_category_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "fixed",           default: false
  end

  create_table "options", force: true do |t|
    t.string   "tag"
    t.binary   "val"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "foursquare_venue_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_categories", force: true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.integer  "order",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
