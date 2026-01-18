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

ActiveRecord::Schema[8.1].define(version: 2026_01_18_040353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "packages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dates"
    t.text "description"
    t.string "duration"
    t.date "end_date"
    t.jsonb "experience_type", default: [], null: false
    t.jsonb "extras", default: {}, null: false
    t.boolean "featured"
    t.text "gpt_prompt"
    t.string "ideal_profile", default: [], array: true
    t.string "keyword"
    t.boolean "kids_friendly", default: false, null: false
    t.integer "max_age"
    t.integer "max_passengers"
    t.integer "min_age"
    t.integer "min_passengers"
    t.decimal "price", precision: 10, scale: 2
    t.string "regime"
    t.string "stars"
    t.date "start_date"
    t.string "title"
    t.jsonb "trip_purpose", default: [], null: false
    t.datetime "updated_at", null: false
    t.index ["experience_type"], name: "index_packages_on_experience_type", using: :gin
    t.index ["extras"], name: "index_packages_on_extras", using: :gin
    t.index ["keyword"], name: "index_packages_on_keyword", unique: true
    t.index ["kids_friendly"], name: "index_packages_on_kids_friendly"
    t.index ["start_date"], name: "index_packages_on_start_date"
    t.index ["trip_purpose"], name: "index_packages_on_trip_purpose", using: :gin
  end

  create_table "questions", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true, null: false
    t.integer "kind", default: 1
    t.string "name", null: false
    t.bigint "package_id", null: false
    t.integer "score"
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_questions_on_kind"
    t.index ["package_id", "enabled"], name: "index_questions_on_package_id_and_enabled"
    t.index ["package_id"], name: "index_questions_on_package_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "questions", "packages"
  add_foreign_key "sessions", "users"
end
