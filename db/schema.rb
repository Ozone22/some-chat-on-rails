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

ActiveRecord::Schema.define(version: 20160822180203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id",    null: false
    t.integer "recipient_id", null: false
  end

  add_index "conversations", ["recipient_id"], name: "index_conversations_on_recipient_id", using: :btree
  add_index "conversations", ["sender_id", "recipient_id"], name: "index_conversations_on_sender_id_and_recipient_id", unique: true, using: :btree
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "text",                        null: false
    t.boolean  "is_readed",   default: false
    t.integer  "dialog_id"
    t.string   "dialog_type"
    t.datetime "created_at"
    t.integer  "sender_id",                   null: false
  end

  add_index "messages", ["dialog_type", "dialog_id"], name: "index_messages_on_dialog_type_and_dialog_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer "friend_id",             null: false
    t.integer "user_id",               null: false
    t.integer "status",    default: 1, null: false
  end

  add_index "relationships", ["friend_id", "user_id"], name: "index_relationships_on_friend_id_and_user_id", unique: true, using: :btree
  add_index "relationships", ["friend_id"], name: "index_relationships_on_friend_id", using: :btree
  add_index "relationships", ["user_id"], name: "index_relationships_on_user_id", using: :btree

  create_table "room_users", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
  end

  add_index "room_users", ["room_id", "user_id"], name: "index_room_users_on_room_id_and_user_id", unique: true, using: :btree
  add_index "room_users", ["room_id"], name: "index_room_users_on_room_id", using: :btree
  add_index "room_users", ["user_id"], name: "index_room_users_on_user_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string "name", limit: 50, default: "some-room", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  null: false
    t.string   "login",                                  null: false
    t.integer  "unread_message_count",   default: 0
    t.string   "password_digest"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_send_at"
    t.string   "confirm_token"
    t.boolean  "email_confirmed",        default: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
