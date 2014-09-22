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

ActiveRecord::Schema.define(:version => 20140920221536) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "deliverable_comments", :force => true do |t|
    t.integer  "deliverable_id"
    t.integer  "comment_type_id"
    t.text     "note"
    t.datetime "created_at"
    t.integer  "creator_id"
  end

  create_table "deliverable_messages", :force => true do |t|
    t.integer  "deliverable_id"
    t.integer  "message_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "is_related",     :default => true
  end

  create_table "deliverable_relations", :force => true do |t|
    t.integer  "status_id"
    t.integer  "source_deliverable_id"
    t.integer  "target_deliverable_id"
    t.integer  "relation_type_id"
    t.integer  "message_thread_id"
    t.integer  "previous_sibling_id"
    t.integer  "message_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "deliverable_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "deliverable_type_config_id"
    t.integer  "user_group_id"
  end

  create_table "deliverables", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
    t.integer  "completed_by_id"
    t.string   "type"
    t.text     "data"
    t.string   "abbreviation"
    t.integer  "status_id"
    t.integer  "creator_id"
    t.integer  "user_group_id"
  end

  create_table "email_account_threads", :force => true do |t|
    t.integer  "email_account_id"
    t.integer  "message_thread_id"
    t.string   "thread_id"
    t.string   "subject"
    t.datetime "start_time"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "user_id"
    t.integer  "status_id",         :default => 2
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

  create_table "email_comment_users", :force => true do |t|
    t.integer "email_comment_id"
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "email_comments", :force => true do |t|
    t.integer  "status_id"
    t.string   "email_message_id"
    t.string   "email_subject"
    t.string   "email_send_time"
    t.string   "email_sender"
    t.integer  "format_id"
    t.text     "comment"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "emails", :force => true do |t|
    t.integer  "email_account_id"
    t.integer  "message_id"
    t.integer  "email_account_thread_id"
    t.string   "thread_id"
    t.string   "web_id"
    t.string   "folder"
    t.datetime "date"
    t.integer  "uid"
    t.string   "guid"
    t.string   "from_address"
    t.string   "subject"
    t.text     "encoded_mail"
    t.text     "data"
    t.datetime "created_at"
    t.integer  "user_id"
    t.string   "snippet"
    t.integer  "status_id",               :default => 2
  end

  create_table "gmail_synchronizations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "last_sync"
    t.integer  "last_history_id", :limit => 8
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "google_authorizations", :force => true do |t|
    t.integer  "user_id"
    t.string   "gplus_id"
    t.string   "refresh_token"
    t.string   "access_token"
    t.integer  "expires_in"
    t.datetime "issued_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "message_threads", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "status_id",  :default => 2
  end

  create_table "messages", :force => true do |t|
    t.integer  "status_id",           :default => 2
    t.integer  "message_thread_id"
    t.string   "envelope_message_id"
    t.integer  "source_email_id"
    t.datetime "created_at"
    t.text     "data"
    t.integer  "user_group_id"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "deliverable_id"
    t.integer  "user_id"
    t.integer  "user_group_id"
    t.boolean  "responsible"
    t.integer  "access_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "visibility_id"
    t.integer  "priority_id"
  end

  create_table "signed_request_users", :force => true do |t|
    t.datetime "created_at"
    t.string   "original_opensocial_app_id"
    t.string   "original_opensocial_app_url"
    t.string   "opensocial_owner_id"
    t.string   "opensocial_container"
    t.integer  "user_id"
  end

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "status_id"
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
    t.string   "first_name"
    t.string   "last_name"
    t.string   "short_name"
    t.integer  "user_group_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
