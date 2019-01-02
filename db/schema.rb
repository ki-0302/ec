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

ActiveRecord::Schema.define(version: 2019_01_02_063936) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category_id"
    t.string "manufacture_name"
    t.string "code"
    t.integer "tax_item_id"
    t.integer "sales_price"
    t.integer "regular_price"
    t.integer "number_of_stocks"
    t.boolean "unlimited_stock", default: false, null: false
    t.datetime "display_start_date"
    t.datetime "display_end_date"
    t.string "description"
    t.string "search_term"
    t.string "jan_code"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_items_on_code", unique: true
  end

end
