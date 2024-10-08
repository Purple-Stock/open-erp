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

ActiveRecord::Schema[7.0].define(version: 2024_09_03_193444) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "account_features", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "feature_id", null: false
    t.boolean "is_enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "bling_order_items", force: :cascade do |t|
    t.string "bling_order_id"
    t.string "codigo"
    t.string "unidade"
    t.integer "quantidade"
    t.decimal "desconto"
    t.decimal "valor"
    t.decimal "aliquotaIPI"
    t.text "descricao"
    t.text "descricaoDetalhada"
    t.string "situation_id"
    t.string "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.datetime "alteration_date"
    t.string "marketplace_code_id"
    t.integer "bling_id"
    t.bigint "account_id"
    t.decimal "value"
    t.jsonb "items"
    t.date "collected_alteration_date"
    t.string "original_situation_id"
    t.index ["account_id"], name: "index_bling_order_items_on_account_id"
    t.index ["bling_order_id"], name: "index_bling_order_items_on_bling_order_id", unique: true
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

  create_table "features", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feature_key", default: 0, null: false
  end

  create_table "finance_data", force: :cascade do |t|
    t.date "date"
    t.decimal "income"
    t.decimal "expense"
    t.decimal "fixed_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
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

  create_table "items", force: :cascade do |t|
    t.string "sku"
    t.integer "unity"
    t.integer "quantity"
    t.decimal "discount"
    t.decimal "value"
    t.decimal "ipi_tax"
    t.string "description"
    t.string "long_description"
    t.bigint "product_id"
    t.integer "account_id"
    t.bigint "bling_order_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "localizations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "number"
    t.string "complement"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "neighborhood"
    t.string "country_name"
    t.integer "account_id"
    t.bigint "bling_order_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "production_products", force: :cascade do |t|
    t.bigint "production_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pieces_delivered"
    t.date "delivery_date"
    t.index ["product_id"], name: "index_production_products_on_product_id"
    t.index ["production_id"], name: "index_production_products_on_production_id"
  end

  create_table "productions", force: :cascade do |t|
    t.datetime "cut_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.bigint "tailor_id"
    t.boolean "consider", default: false
    t.integer "pieces_missing"
    t.date "expected_delivery_date"
    t.boolean "confirmed"
    t.boolean "paid"
    t.text "observation"
    t.string "service_order_number"
    t.index ["account_id"], name: "index_productions_on_account_id"
    t.index ["cut_date"], name: "index_productions_on_cut_date"
    t.index ["expected_delivery_date"], name: "index_productions_on_expected_delivery_date"
    t.index ["tailor_id"], name: "index_productions_on_tailor_id"
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
    t.bigint "bling_id"
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

  create_table "revenue_estimations", force: :cascade do |t|
    t.decimal "average_ticket"
    t.integer "quantity"
    t.decimal "revenue"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "shein_orders", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_shein_orders_on_account_id"
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

  create_table "stocks", force: :cascade do |t|
    t.integer "product_id"
    t.bigint "bling_product_id"
    t.integer "total_balance"
    t.integer "total_virtual_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
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

  create_table "tailors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_tailors_on_account_id"
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
  add_foreign_key "production_products", "productions"
  add_foreign_key "production_products", "products"
  add_foreign_key "productions", "accounts"
  add_foreign_key "productions", "tailors"
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
