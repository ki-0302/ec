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

ActiveRecord::Schema.define(version: 2019_01_13_153549) do

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

  create_table "categories", force: :cascade do |t|
    t.bigint "parent_id"
    t.string "name", null: false
    t.datetime "display_start_datetime"
    t.datetime "display_end_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id"
    t.string "manufacture_name"
    t.string "code"
    t.bigint "tax_item_id", null: false
    t.integer "sales_price"
    t.integer "regular_price"
    t.integer "number_of_stocks"
    t.boolean "unlimited_stock", default: true, null: false
    t.datetime "display_start_datetime"
    t.datetime "display_end_datetime"
    t.string "description"
    t.string "search_term"
    t.string "jan_code"
    t.integer "status_code", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["tax_item_id"], name: "index_products_on_tax_item_id"
  end

  create_table "tax_classes", force: :cascade do |t|
    t.string "name"
    t.float "tax_rate", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tax_items", force: :cascade do |t|
    t.string "name"
    t.bigint "tax_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tax_class_id"], name: "index_tax_items_on_tax_class_id"
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "tax_items"
  add_foreign_key "tax_items", "tax_classes"
end
