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

ActiveRecord::Schema[7.0].define(version: 2023_10_13_103251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "credential_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "credential_id"
    t.string "method_type"
    t.string "name"
    t.string "author"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credential_id"], name: "index_credential_events_on_credential_id"
    t.index ["event_id"], name: "index_credential_events_on_event_id"
  end

  create_table "credentials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "institution_id", null: false
    t.string "name"
    t.string "author"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_credentials_on_institution_id"
  end

  create_table "event_metadatas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "credential_id"
    t.uuid "credential_event_id"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credential_event_id"], name: "index_event_metadatas_on_credential_event_id"
    t.index ["credential_id"], name: "index_event_metadatas_on_credential_id"
    t.index ["event_id"], name: "index_event_metadatas_on_event_id"
  end

  create_table "event_state_transitions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "most_recent"], name: "index_event_state_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["event_id", "sort_key"], name: "index_event_state_transitions_parent_sort", unique: true
    t.index ["event_id"], name: "index_event_state_transitions_on_event_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "institution_id"
    t.uuid "user_id"
    t.string "title"
    t.jsonb "metadata"
    t.string "state"
    t.float "estimated_cost"
    t.datetime "estimated_cost_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_events_on_institution_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "institutions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "institution_id", null: false
    t.string "role_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_roles_on_institution_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "credential_events", "credentials"
  add_foreign_key "credential_events", "events"
  add_foreign_key "credentials", "institutions"
  add_foreign_key "event_metadatas", "credential_events"
  add_foreign_key "event_metadatas", "credentials"
  add_foreign_key "event_metadatas", "events"
  add_foreign_key "event_state_transitions", "events", on_delete: :cascade
  add_foreign_key "events", "institutions"
  add_foreign_key "events", "users"
  add_foreign_key "roles", "institutions"
  add_foreign_key "roles", "users"
end
