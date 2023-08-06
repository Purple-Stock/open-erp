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

ActiveRecord::Schema[7.0].define(version: 2023_08_06_095741) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "company_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bling_data", force: :cascade do |t|
    t.string "access_token"
    t.integer "expires_in"
    t.datetime "expires_at"
    t.string "token_type"
    t.text "scope"
    t.string "refresh_token"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_bling_data_on_account_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_categories_on_account_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "cellphone"
    t.string "phone"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_customers_on_account_id"
  end

  create_table "group_products", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_products_on_group_id"
    t.index ["product_id"], name: "index_group_products_on_product_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "months", default: 1
  end

  create_table "post_data", force: :cascade do |t|
    t.string "client_name"
    t.string "cep"
    t.string "state"
    t.string "post_code"
    t.string "post_type"
    t.float "value"
    t.datetime "send_date", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "bar_code"
    t.boolean "highlight"
    t.bigint "category_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "custom_id"
    t.string "sku"
    t.string "extra_sku"
    t.integer "account_id"
    t.integer "store_id"
    t.index ["account_id"], name: "index_products_on_account_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "purchase_products", force: :cascade do |t|
    t.integer "quantity"
    t.float "value"
    t.bigint "product_id"
    t.bigint "purchase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_entrance", default: 0
    t.integer "account_id"
    t.index ["account_id"], name: "index_purchase_products_on_account_id"
    t.index ["product_id"], name: "index_purchase_products_on_product_id"
    t.index ["purchase_id"], name: "index_purchase_products_on_purchase_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.float "value"
    t.bigint "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_purchases_on_supplier_id"
  end

  create_table "sale_products", force: :cascade do |t|
    t.integer "quantity"
    t.float "value"
    t.bigint "product_id"
    t.bigint "sale_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_sale_products_on_account_id"
    t.index ["product_id"], name: "index_sale_products_on_product_id"
    t.index ["sale_id"], name: "index_sale_products_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.float "value"
    t.float "discount"
    t.float "percentage"
    t.boolean "online"
    t.boolean "disclosure"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_type", default: 0
    t.boolean "exchange", default: false
    t.string "order_code"
    t.integer "store_sale", default: 0
    t.float "total_exchange_value"
    t.integer "account_id"
    t.index ["account_id"], name: "index_sales_on_account_id"
    t.index ["customer_id"], name: "index_sales_on_customer_id"
  end

  create_table "simplo_clients", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "order_date", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simplo_item_sales", force: :cascade do |t|
    t.string "produto_id"
    t.string "sku"
    t.string "nome_produto"
    t.integer "quantidade"
    t.float "valor_unitario"
    t.float "valor_total"
    t.float "peso"
    t.float "desconto"
    t.datetime "data_pedido", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_id"
  end

  create_table "simplo_items", force: :cascade do |t|
    t.string "sku"
    t.integer "quantity"
    t.bigint "simplo_order_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_simplo_items_on_product_id"
    t.index ["simplo_order_id"], name: "index_simplo_items_on_simplo_order_id"
  end

  create_table "simplo_order_payments", force: :cascade do |t|
    t.string "order_id"
    t.string "client_name"
    t.string "integrador"
    t.string "pagamento_forma"
    t.string "codigo_transacao"
    t.string "parcelas"
    t.string "total"
    t.string "data_pedido"
    t.string "order_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simplo_orders", force: :cascade do |t|
    t.string "client_name"
    t.string "order_id"
    t.string "order_status"
    t.string "order_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simplo_products", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_stores_on_account_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "email"
    t.string "cellphone"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "landmark"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_suppliers_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "company_name"
    t.string "cpf_cnpj"
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "group_products", "groups"
  add_foreign_key "group_products", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "purchase_products", "products"
  add_foreign_key "purchase_products", "purchases"
  add_foreign_key "purchases", "suppliers"
  add_foreign_key "sale_products", "products"
  add_foreign_key "sale_products", "sales"
  add_foreign_key "sales", "customers"
  add_foreign_key "simplo_items", "products"
  add_foreign_key "simplo_items", "simplo_orders"
end
