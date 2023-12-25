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

ActiveRecord::Schema[7.0].define(version: 2023_12_25_111340) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "cancellations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_email", null: false
    t.string "user_username", null: false
    t.datetime "user_created_at", null: false
    t.datetime "user_updated_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_stripe_customer_id"
  end

  create_table "checkout_sessions", force: :cascade do |t|
    t.bigint "user_patron_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["order_id"], name: "index_checkout_sessions_on_order_id"
    t.index ["user_patron_id"], name: "index_checkout_sessions_on_user_patron_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "sku"
    t.string "name", null: false
    t.integer "max_ingredient_storage_life", null: false
    t.integer "max_ingredient_delivery_time", null: false
    t.integer "price_base", default: 0, null: false
    t.integer "price_with_tax_base", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "description"
    t.integer "currency", default: 0
    t.index ["user_id"], name: "index_menu_items_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "size", null: false
    t.integer "payment_amount_base", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "item_status", default: 0, null: false
    t.bigint "tokujo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_patron_id", null: false
    t.string "stripe_setup_intent_id"
    t.string "stripe_payment_intent_id"
    t.integer "payment_amount_currency"
    t.index ["tokujo_id"], name: "index_orders_on_tokujo_id"
    t.index ["user_patron_id"], name: "index_orders_on_user_patron_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "tokujos", force: :cascade do |t|
    t.datetime "order_period_ends_at"
    t.datetime "closed_at"
    t.integer "status", default: 0, null: false
    t.integer "number_of_items_available"
    t.integer "number_of_items_taken"
    t.bigint "menu_item_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_collection_timing", null: false
    t.string "headline"
    t.integer "ingredients_procurement_time"
    t.integer "ingredients_expiration_time"
    t.datetime "order_period_starts_at"
    t.datetime "eat_period_starts_at"
    t.datetime "eat_period_ends_at"
    t.index ["menu_item_id"], name: "index_tokujos_on_menu_item_id"
    t.index ["user_id"], name: "index_tokujos_on_user_id"
  end

  create_table "user_patrons", force: :cascade do |t|
    t.string "email", null: false
    t.string "stripe_customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "username"
    t.string "password_digest", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_token_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_account_id"
    t.string "stripe_customer_id"
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "checkout_sessions", "orders"
  add_foreign_key "checkout_sessions", "user_patrons"
  add_foreign_key "menu_items", "users"
  add_foreign_key "orders", "tokujos"
  add_foreign_key "orders", "user_patrons"
  add_foreign_key "tokujos", "menu_items"
  add_foreign_key "tokujos", "users"
end
