# frozen_string_literal: true

Rails.application.routes.draw do
  # mount Sidekiq::Web => '/sidekiq'
  mount GoodJob::Engine => 'good_job'

  resources :productions do
    collection do
      get 'missing_pieces'
      get 'products_in_production_report'
      get 'unpaid_confirmed'  # Add this line
      get 'price_per_piece_report'
      get 'calendar'
    end
    member do
      patch :verify
      get :service_order_pdf
      get :payment_order_pdf  # Add this line
    end
  end

  resources :tailors
  get 'dashboards/others_status'

  resources :bling_order_items

  resources :bling_order_item_histories, only: :index do
    collection do
      get :day_quantities
    end
  end

  resources :bling_order_item_owners, only: :index do
    collection do
      get :day_quantities
      get :verification
    end
  end

  resources :shein_bling_order_items, only: :index

  resources :shein_dashboards
  resources :shein_orders do
    collection do
      get :upload
      post :import
    end
  end

  resources :finance_data do
    collection do
      get :upload
      post :import
    end
  end

  devise_for :users

  resources :stocks do
    member do
      patch :apply_discount
    end
  end
  resources :revenue_estimations
  resources :accounts
  resources :purchase_products
  resources :stores
  get 'set_locale', to: 'locales#set_locale'
  get 'purchase_products_defer', to: 'purchase_products#index_defer'
  get 'inventory_view', to: 'purchase_products#inventory_view', as: 'inventory_view'
  post 'save_inventory', to: 'purchase_products#save_inventory', as: 'save_inventory'
  get 'reports/daily_sale', to: 'reports#daily_sale'
  get 'reports/all_reports', to: 'reports#all_reports', as: 'all_reports'
  get 'reports/payment', to: 'reports#payment', as: 'payment'
  get 'reports/top_selling_products', to: 'reports#top_selling_products', as: 'top_selling_products'
  resources :purchases
  resources :suppliers
  resources :sales
  get 'sales_defer', to: 'sales#index_defer'
  get 'insert_orders', to: 'sales#insert_orders', as: 'insert_orders'
  post 'save_orders', to: 'sales#save_orders', as: 'save_orders'
  get 'stock_transfer', to: 'purchase_products#stock_transfer', as: 'stock_transfer'
  post 'save_stock_transfer', to: 'purchase_products#save_stock_transfer', as: 'save_stock_transfer'
  resources :sale_products
  resources :products do
    member do
      delete :destroy_from_index
      get 'download_qr_code'
      get 'scan_qr_code'  # Page with camera scanner
      post 'update_stock_from_qr' # Endpoint to update stock
      get :qr_code
    end
  end
  resources :bling_data, only: %i[index show]
  get 'products_defer', to: 'products#index_defer'
  get 'products_tags_defer', to: 'products#tags_index_defer'
  get '/products/:id/duplicate', to: 'products#duplicate', as: 'meeting_duplicate'
  get '/products/:id/update_active', to: 'products#update_active', as: 'update_product_active'
  resources :items, only: [] do
    member do
      patch :update_status
    end
  end

  resources :customers do
    collection do
      post :import
    end
  end

  get '/home/last_updates', to: 'home#last_updates', as: 'home_last_updates'
  get '/integrations/index', to: 'integrations#index', as: 'integrations_list'

  resources :categories
  resources :groups
  resources :group_products
  get 'group_lists', to: 'groups#show_group_product', as: 'show_group_product'
  get 'confection_lists', to: 'groups#show_product_confection', as: 'show_product_confection'
  get 'orders_control', to: 'orders_control#show_orders_control', as: 'show_orders_control'
  get 'pending_orders', to: 'orders_control#show_pending_orders', as: 'show_pending_orders'
  get 'pending_product_planning', to: 'orders_control#show_pending_product_planning', as: 'show_pending_product_planning'
  get 'orders_products_stock', to: 'orders_control#show_orders_products_stock', as: 'show_orders_products_stock'
  get 'orders_business_day', to: 'orders_control#show_orders_business_day', as: 'show_orders_business_day'
  get '/orders/post_mail_control', to: 'orders_control#post_mail_control', as: 'show_post_mail_control'
  post 'orders_control/import_post_mail' => 'orders_control#import_post_mail', as: 'import_post_mail'

  get 'bling_order_items', to: 'bling_order_items#index'

  resources :checkout_orders, only: [:index] do
    collection do
      post :process_file
      post :update_selected_orders
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'bling/pedidos', to: 'bling/orders#show', as: 'show_bling_orders'
      get 'bling/get-token' => 'bling/orders#get_token'
      get 'products/:custom_id', to: 'products#show', as: 'show'
      get 'sale_products/:id', to: 'products#show_product', as: 'show_product'
      get 'products', to: 'products#index', as: 'index'
      get 'account/:id/checkout_orders/:package_id', to: 'checkout/orders#find_order'
      post 'purchase_products/add_products', to: 'purchase_products#add_products', as: 'add_products'
      post 'sale_products/remove_products', to: 'sale_products#remove_products', as: 'remove_products'
      post 'purchase_products/add_inventory_quantity', to: 'purchase_products#add_inventory_quantity',
                                                       as: 'add_inventory_quantity'
      get 'products/find_by_sku/:sku', to: 'products#find_by_sku', as: 'find_product_by_sku'
      get 'products/:id/show_by_id', to: 'products#show_by_id', as: 'show_product_by_id'
      post 'bling/stock', to: 'bling#update_stock'
    end
  end
  root to: 'home#index'
  
  resources :accounts do
    resources :productions do
      member do
        get :verify
      end
    end
  end

  resources :warehouses

  resources :bling_order_items do
    collection do
      get :export_csv
    end
  end

  get 'dashboards/revenue_target_report', to: 'dashboards#revenue_target_report', as: 'dashboards_revenue_target_report'

  resources :bling_order_items do
    collection do
      get :export_csv
    end
  end

  get 'dashboards/status_summary', to: 'dashboards#status_summary', as: 'dashboards_status_summary'

  resources :bling_module_situations

  get 'qr_scanner', to: 'qr_scanner#index', as: 'qr_scanner'

end
