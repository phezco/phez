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

ActiveRecord::Schema.define(version: 20150716055131) do

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

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.integer  "subphez_id",                 null: false
    t.string   "guid",                       null: false
    t.string   "url"
    t.string   "title",                      null: false
    t.integer  "vote_total", default: 0,     null: false
    t.boolean  "is_self",    default: false, null: false
    t.text     "body"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "points",     default: 0
    t.integer  "hot_score",  default: 0
  end

  create_table "subphezes", force: :cascade do |t|
    t.integer  "user_id",                       null: false
    t.string   "path",                          null: false
    t.string   "title",                         null: false
    t.text     "sidebar"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "is_admin_only", default: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "subphez_id", null: false
    t.datetime "created_at", null: false
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
