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

ActiveRecord::Schema.define(version: 20141220060601) do

  create_table "payments", force: true do |t|
    t.string   "message"
    t.string   "name"
    t.string   "email"
    t.float    "amount"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "success",    default: false
    t.string   "secure_id"
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id"

  create_table "subscription_payments", force: true do |t|
    t.integer  "subscription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscription_payments", ["subscription_id"], name: "index_subscription_payments_on_subscription_id"

  create_table "subscriptions", force: true do |t|
    t.integer  "plan"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_id"
  end

  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "url_handle"
    t.string   "company_name"
    t.string   "company_description"
    t.string   "avatar"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_uid"
    t.string   "stripe_access_token"
    t.string   "stripe_customer_id"
    t.string   "stripe_pub_key"
  end

end
