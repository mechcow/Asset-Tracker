# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110228115512) do

  create_table "assets", :force => true do |t|
    t.integer "user_id",            :null => false
    t.integer "inventoriable_id"
    t.integer "location_id"
    t.integer "model_id"
    t.string  "inventoriable_type"
    t.string  "name"
    t.string  "notes"
    t.string  "serial"
  end

  create_table "controllers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "environments", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "examples", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interfaces", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "machine_id"
    t.string   "ipaddr"
    t.string   "mac"
    t.integer  "mtu"
    t.string   "gateway"
    t.string   "netmask"
    t.integer  "master_id"
  end

  create_table "kinds", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name",            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timezone"
    t.string   "dns"
    t.string   "puppetmaster_ip"
    t.string   "centos_ip"
    t.integer  "vifs"
  end

  create_table "machines", :force => true do |t|
    t.string  "type",                          :null => false
    t.string  "cpu"
    t.string  "disk_type"
    t.string  "vgname"
    t.boolean "isdom0",     :default => false
    t.integer "ram"
    t.integer "vcpus"
    t.integer "disk_space"
    t.integer "parent_id"
  end

  create_table "machines_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "machine_id"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "models", :force => true do |t|
    t.string   "name",            :null => false
    t.integer  "kind_id",         :null => false
    t.integer  "manufacturer_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.integer "required_swap",  :default => 0
    t.integer "extra_log_size"
    t.string  "name"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer "tag_id",        :null => false
    t.integer "taggable_id",   :null => false
    t.string  "taggable_type", :null => false
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "user_roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                 :null => false
    t.string   "email",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "site_admin",         :default => false
  end

  create_table "vips", :force => true do |t|
    t.string   "description"
    t.string   "ipaddr"
    t.string   "puppet_variable_name"
    t.integer  "location_id",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
