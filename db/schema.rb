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

ActiveRecord::Schema.define(:version => 20131201232417) do

  create_table "conversation_imports", :force => true do |t|
    t.integer  "status_id"
    t.integer  "email_account_conversation_id"
    t.integer  "process_pending_imports_id"
    t.integer  "delayed_job_id"
    t.integer  "delayed_job_status_id"
    t.text     "delayed_job_log"
    t.string   "delayed_job_method"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "conversations", :force => true do |t|
    t.integer  "status_id"
    t.integer  "party_id"
    t.datetime "created_at"
  end

  create_table "email_account_conversations", :force => true do |t|
    t.integer  "status_id"
    t.integer  "party_id"
    t.integer  "conversation_id"
    t.integer  "email_account_id"
    t.string   "thread_id"
    t.datetime "created_at"
  end

  create_table "email_accounts", :force => true do |t|
    t.integer  "status_id"
    t.integer  "user_id"
    t.string   "username"
    t.string   "authentication_string"
    t.string   "server"
    t.integer  "port"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "email_accounts", ["username"], :name => "index_email_accounts_on_username", :unique => true

  create_table "emails", :force => true do |t|
    t.integer  "email_account_id"
    t.string   "thread_id"
    t.string   "folder"
    t.datetime "date"
    t.string   "uid"
    t.string   "guid"
    t.string   "subject"
    t.text     "encoded_mail"
    t.datetime "created_at"
    t.text     "data"
  end

  create_table "messages", :force => true do |t|
    t.integer  "status_id"
    t.integer  "conversation_id"
    t.string   "envelope_message_id"
    t.integer  "source_email_id"
    t.datetime "created_at"
    t.text     "data"
  end

  create_table "parties", :force => true do |t|
    t.integer  "status_id"
    t.string   "name"
    t.text     "description"
    t.integer  "creator_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "index_timestamp"
    t.string   "luid"
  end

  create_table "party_users", :force => true do |t|
    t.integer  "status_id"
    t.integer  "party_id"
    t.integer  "user_id"
    t.integer  "party_role_id"
    t.datetime "created_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
