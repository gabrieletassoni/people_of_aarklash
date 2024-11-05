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

ActiveRecord::Schema[7.1].define(version: 2024_10_28_152811) do
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

  create_table "affiliations", force: :cascade do |t|
    t.string "name"
    t.bigint "army_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["army_id"], name: "index_affiliations_on_army_id"
    t.index ["name", "army_id"], name: "index_affiliations_on_name_and_army_id", unique: true
  end

  create_table "armies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_armies_on_name", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "entity_modifiers", force: :cascade do |t|
    t.bigint "modifier_id", null: false
    t.string "entity_type", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_type", "entity_id"], name: "index_entity_modifiers_on_entity"
    t.index ["modifier_id"], name: "index_entity_modifiers_on_modifier_id"
  end

  create_table "modifier_relationships", force: :cascade do |t|
    t.bigint "modifier_id", null: false
    t.bigint "related_modifier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modifier_id"], name: "index_modifier_relationships_on_modifier_id"
    t.index ["related_modifier_id"], name: "index_modifier_relationships_on_related_modifier_id"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string "name"
    t.decimal "mov", precision: 3, scale: 1, default: "0.0"
    t.integer "ini", default: 0
    t.integer "att", default: 0
    t.integer "str", default: 0
    t.integer "def", default: 0
    t.integer "res", default: 0
    t.integer "aim", default: 0
    t.integer "cou", default: 0
    t.integer "fea", default: 0
    t.integer "dis", default: 0
    t.integer "pow", default: 0
    t.integer "rank", default: 0
    t.integer "wounds", default: 0
    t.integer "force", default: 0
    t.integer "cost", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.integer "character_cost"
    t.string "special_cost"
    t.index ["category_id"], name: "index_modifiers_on_category_id"
    t.index ["name"], name: "index_modifiers_on_name", unique: true
    t.index ["special_cost"], name: "index_modifiers_on_special_cost"
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

  create_table "profiles", force: :cascade do |t|
    t.decimal "mov", precision: 3, scale: 1
    t.integer "ini", default: 0
    t.integer "att", default: 0
    t.integer "str", default: 0
    t.integer "def", default: 0
    t.integer "res", default: 0
    t.integer "aim", default: 0
    t.integer "cou", default: 0
    t.integer "fea", default: 0
    t.integer "dis", default: 0
    t.integer "pow", default: 0
    t.integer "rank", default: 0
    t.integer "wounds", default: 0
    t.integer "force", default: 0
    t.integer "cost", default: 0
    t.bigint "unit_id", null: false
    t.bigint "affiliation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affiliation_id"], name: "index_profiles_on_affiliation_id"
    t.index ["unit_id"], name: "index_profiles_on_unit_id"
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
    t.text "raw"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_thecore_settings_on_key"
    t.index ["ns", "key"], name: "index_thecore_settings_on_ns_and_key", unique: true
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.bigint "army_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "character", default: false, null: false
    t.index ["army_id"], name: "index_units_on_army_id"
    t.index ["name"], name: "index_units_on_name", unique: true
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
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "affiliations", "armies"
  add_foreign_key "entity_modifiers", "modifiers"
  add_foreign_key "modifier_relationships", "modifiers"
  add_foreign_key "modifier_relationships", "modifiers", column: "related_modifier_id"
  add_foreign_key "modifiers", "categories"
  add_foreign_key "permission_roles", "permissions"
  add_foreign_key "permission_roles", "roles"
  add_foreign_key "permissions", "actions"
  add_foreign_key "permissions", "predicates"
  add_foreign_key "permissions", "targets"
  add_foreign_key "profiles", "affiliations"
  add_foreign_key "profiles", "units"
  add_foreign_key "role_users", "roles"
  add_foreign_key "role_users", "users"
  add_foreign_key "units", "armies"
  add_foreign_key "used_tokens", "users"
end
