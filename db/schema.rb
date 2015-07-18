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

ActiveRecord::Schema.define(version: 20150718145759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comment_votes", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "comment_id", null: false
    t.integer  "vote_value", null: false
    t.datetime "created_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted",       default: false
    t.boolean  "is_rewarded",      default: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.integer  "from_user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "messageable_id"
    t.string   "messageable_type"
    t.string   "reason"
  end

  create_table "mod_requests", force: :cascade do |t|
    t.integer  "inviting_user_id", null: false
    t.integer  "user_id",          null: false
    t.integer  "subphez_id",       null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "moderations", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "subphez_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.integer  "subphez_id",                      null: false
    t.string   "guid",                            null: false
    t.string   "url"
    t.string   "title",                           null: false
    t.integer  "vote_total",      default: 0,     null: false
    t.boolean  "is_self",         default: false, null: false
    t.text     "body"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "points",          default: 0
    t.integer  "hot_score",       default: 0
    t.boolean  "is_premium_only", default: false
    t.boolean  "is_rewarded",     default: false
  end

  create_table "rewards", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount_usd"
    t.float    "amount_mbtc"
    t.integer  "confirmations_count", default: 0,     null: false
    t.integer  "rewarded_user_id"
    t.integer  "rewardable_id"
    t.string   "rewardable_type"
    t.integer  "months"
    t.boolean  "payment_confirmed",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "funding_source"
  end

  create_table "subphezes", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.string   "path",                            null: false
    t.string   "title",                           null: false
    t.text     "sidebar"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_admin_only",   default: false
    t.boolean  "is_premium_only", default: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "subphez_id", null: false
    t.datetime "created_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount_mbtc"
    t.string   "txn_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "username"
    t.boolean  "orange",                 default: false
    t.boolean  "is_admin",               default: false
    t.string   "remember_token"
    t.string   "bitcoin_address"
    t.boolean  "is_premium"
    t.integer  "premium_months",         default: 0
    t.datetime "premium_since"
    t.datetime "premium_until"
    t.integer  "rewardable_months",      default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "post_id",    null: false
    t.integer  "vote_value", null: false
    t.datetime "created_at", null: false
  end

end
