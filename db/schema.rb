# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_18_153622) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "actions", force: :cascade do |t|
    t.string "name"
    t.bigint "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_actions_on_name", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_categories_on_description"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "charts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "chart_library_name"
    t.index ["chart_library_name"], name: "index_charts_on_chart_library_name", unique: true
    t.index ["name"], name: "index_charts_on_name", unique: true
  end

  create_table "collected_data", force: :cascade do |t|
    t.bigint "thing_id", null: false
    t.bigint "user_id", null: false
    t.jsonb "json_data"
    t.datetime "injested_at"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "data_configuration_id"
    t.text "address"
    t.index ["address"], name: "index_collected_data_on_address"
    t.index ["data_configuration_id"], name: "index_collected_data_on_data_configuration_id"
    t.index ["latitude", "longitude"], name: "index_collected_data_on_latitude_and_longitude"
    t.index ["thing_id"], name: "index_collected_data_on_thing_id"
    t.index ["user_id"], name: "index_collected_data_on_user_id"
  end

  create_table "custom_dashboard_data_configurations", force: :cascade do |t|
    t.bigint "custom_dashboard_id", null: false
    t.bigint "data_configuration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_dashboard_id"], name: "idx_on_custom_dashboard_id_a3eb23159d"
    t.index ["data_configuration_id"], name: "idx_on_data_configuration_id_1163724a13"
  end

  create_table "custom_dashboards", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_custom_dashboards_on_name"
    t.index ["user_id"], name: "index_custom_dashboards_on_user_id"
  end

  create_table "data_configuration_timespans", force: :cascade do |t|
    t.bigint "data_configuration_id", null: false
    t.bigint "timespan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_configuration_id"], name: "index_data_configuration_timespans_on_data_configuration_id"
    t.index ["timespan_id"], name: "index_data_configuration_timespans_on_timespan_id"
  end

  create_table "data_configurations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.boolean "visible"
    t.boolean "compare_with_same_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chart_id"
    t.string "code"
    t.text "description"
    t.index ["chart_id"], name: "index_data_configurations_on_chart_id"
    t.index ["code", "user_id"], name: "index_data_configurations_on_code_and_user_id", unique: true
    t.index ["description"], name: "index_data_configurations_on_description"
    t.index ["name"], name: "index_data_configurations_on_name"
  end

  create_table "permission_roles", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.bigint "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_permission_roles_on_permission_id"
    t.index ["role_id"], name: "index_permission_roles_on_role_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "predicate_id", null: false
    t.bigint "action_id", null: false
    t.bigint "target_id", null: false
    t.bigint "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_id"], name: "index_permissions_on_action_id"
    t.index ["predicate_id"], name: "index_permissions_on_predicate_id"
    t.index ["target_id"], name: "index_permissions_on_target_id"
  end

  create_table "predicates", force: :cascade do |t|
    t.string "name"
    t.bigint "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_predicates_on_name", unique: true
  end

  create_table "role_users", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_users_on_role_id"
    t.index ["user_id"], name: "index_role_users_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.bigint "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "targets", force: :cascade do |t|
    t.string "name"
    t.bigint "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_targets_on_name", unique: true
  end

  create_table "thecore_settings", force: :cascade do |t|
    t.boolean "enabled", default: true
    t.string "kind", default: "string", null: false
    t.string "ns", default: "main"
    t.string "key", null: false
    t.float "latitude"
    t.float "longitude"
    t.text "raw"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_thecore_settings_on_key"
    t.index ["ns", "key"], name: "index_thecore_settings_on_ns_and_key", unique: true
  end

  create_table "things", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_things_on_category_id"
    t.index ["description"], name: "index_things_on_description"
    t.index ["name"], name: "index_things_on_name", unique: true
    t.index ["user_id"], name: "index_things_on_user_id"
  end

  create_table "timespans", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "duration"
    t.text "description"
    t.index ["description"], name: "index_timespans_on_description"
    t.index ["duration"], name: "index_timespans_on_duration"
    t.index ["name"], name: "index_timespans_on_name", unique: true
  end

  create_table "used_tokens", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.boolean "is_valid", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_used_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_used_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "admin", default: false, null: false
    t.bigint "lock_version"
    t.boolean "locked", default: false, null: false
    t.string "encrypted_access_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["encrypted_access_token"], name: "index_users_on_encrypted_access_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collected_data", "data_configurations"
  add_foreign_key "collected_data", "things"
  add_foreign_key "collected_data", "users"
  add_foreign_key "custom_dashboard_data_configurations", "custom_dashboards"
  add_foreign_key "custom_dashboard_data_configurations", "data_configurations"
  add_foreign_key "custom_dashboards", "users"
  add_foreign_key "data_configuration_timespans", "data_configurations"
  add_foreign_key "data_configuration_timespans", "timespans"
  add_foreign_key "data_configurations", "charts"
  add_foreign_key "data_configurations", "users"
  add_foreign_key "permission_roles", "permissions"
  add_foreign_key "permission_roles", "roles"
  add_foreign_key "permissions", "actions"
  add_foreign_key "permissions", "predicates"
  add_foreign_key "permissions", "targets"
  add_foreign_key "role_users", "roles"
  add_foreign_key "role_users", "users"
  add_foreign_key "things", "categories"
  add_foreign_key "things", "users"
  add_foreign_key "used_tokens", "users"
end
