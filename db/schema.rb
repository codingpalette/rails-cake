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

ActiveRecord::Schema[8.0].define(version: 2025_12_08_022756) do
  create_table "bakeries", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "phone"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "operating_hours"
    t.string "postcode"
    t.string "road_address"
    t.string "jibun_address"
    t.string "detail_address"
    t.string "extra_address"
    t.json "cloudflare_image_ids", default: []
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "bakery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bakery_id"], name: "index_favorites_on_bakery_id"
    t.index ["user_id", "bakery_id"], name: "index_favorites_on_user_id_and_bakery_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "bakery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cloudflare_image_id"
    t.index ["bakery_id"], name: "index_menu_items_on_bakery_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "bakery_id", null: false
    t.text "content"
    t.date "visit_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_public", default: false, null: false
    t.json "cloudflare_image_ids", default: []
    t.index ["bakery_id"], name: "index_notes_on_bakery_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "cloudflare_profile_image_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "favorites", "bakeries"
  add_foreign_key "favorites", "users"
  add_foreign_key "menu_items", "bakeries"
  add_foreign_key "notes", "bakeries"
  add_foreign_key "notes", "users"
  add_foreign_key "sessions", "users"
end
