# frozen_string_literal: true

class OrdersControlController < ApplicationController
  def show_orders_control
    @send_orders = []
    list_orders
    # unique_order
    @orders.each do |order|
      # if order['Wspedido']['pedidostatus_id'] == '23' || order['Wspedido']['pedidostatus_id'] == '3'
      @send_orders << order
      # end
    end
    @send_orders
  end

  def show_orders_products_stock
    @products = Product.includes(:purchase_products, simplo_items: [:simplo_order])
                       .where(simplo_orders: { order_status: %w[2 30 31] })
                       .where(account_id: current_tenant.id)
                       .order(custom_id: :desc)
  end

  def show_pending_orders
    situation_id = params[:situation_id]
    store_id = params[:store_id]
    @resolution_status = params[:resolution_status] || 'unresolved'

    cleaned_situation_ids = if situation_id.present?
                              situation_id.split(',').map(&:to_i)
                            else
                              BlingOrderItem::Status::PENDING
                            end

    items = Item.includes(:bling_order_item).where(bling_order_items: { situation_id: cleaned_situation_ids })

    items = items.where(bling_order_items: { store_id: }) if store_id.present?

    @all_items = case @resolution_status
                 when 'unresolved'
                   items.unresolved
                 when 'resolved'
                   items.resolved
                 else
                   items
                 end

    # Group items by store and sort by total quantity
    @sorted_stores = @all_items.group_by { |item| item.bling_order_item.store_name }
                               .sort_by { |_, items| -items.sum(&:quantity) }
                               .to_h

    respond_to do |format|
      format.html # show.html.erb
      format.csv { send_data generate_csv(@all_items), filename: "orders-#{Date.today}.csv" }
    end
  end

  def show_pending_product_planning
    situation_id = params[:situation_id]
    store_id = params[:store_id]
    @resolution_status = params[:resolution_status] || 'unresolved'
    @color_filter = params[:color]

    cleaned_situation_ids = if situation_id.present?
                              situation_id.split(',').map(&:to_i)
                            else
                              BlingOrderItem::Status::PENDING
                            end

    items = Item.includes(:bling_order_item).where(bling_order_items: { situation_id: cleaned_situation_ids })

    items = items.where(bling_order_items: { store_id: }) if store_id.present?

    @all_items = case @resolution_status
                 when 'unresolved'
                   items.unresolved
                 when 'resolved'
                   items.resolved
                 else
                   items
                 end

    # Group items by SKU and sort by total quantity
    @sorted_items = @all_items.group_by(&:sku)
                              .sort_by { |_, sku_items| -sku_items.sum(&:quantity) }
                              .to_h

    # Fetch stock balances for all SKUs
    skus = @sorted_items.keys
    @stock_balances = Stock.joins(:product).where(products: { sku: skus }).pluck('products.sku', :total_balance).to_h

    # Fetch total pieces missing for all SKUs
    @total_pieces_missing = ProductionProduct.joins(:product)
                                           .where(products: { sku: skus })
                                           .group('products.sku')
                                           .sum('quantity - COALESCE(pieces_delivered, 0)')

    # Group items by SKU-pai + cor
    @sorted_items_by_color = @all_items.group_by do |item|
      sku_parts = item.sku.split('-')
      color = sku_parts[-2]
      sku_pai_with_color = sku_parts[0..-3].join('-') + "-#{color}"
      [sku_pai_with_color, color]
    end.sort_by { |_, sku_color_items| -sku_color_items.sum(&:quantity) }.to_h

    # Apply color filter if present
    if @color_filter.present?
      @sorted_items_by_color = @sorted_items_by_color.select { |_, color| color.downcase == @color_filter.downcase }
    end

    @total_pieces_missing_by_color = calculate_total_pieces_missing(@sorted_items_by_color)

    # Group items by SKU-pai
    @sorted_items_by_sku_pai = @all_items.group_by do |item|
      sku_parts = item.sku.split('-')
      sku_pai = sku_parts[0..-3].join('-')
      sku_pai
    end.sort_by { |_, sku_pai_items| -sku_pai_items.sum(&:quantity) }.to_h

    @total_pieces_missing_by_sku_pai = calculate_total_pieces_missing(@sorted_items_by_sku_pai)

    # Set the default tab to 'pending_missing'
    @active_tab = params[:tab] || 'pending_missing'

    @sold_last_30_days = calculate_sold_last_30_days

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@all_items), filename: "pending-products-#{Date.today}.csv" }
    end
  end

  def show_orders_business_day
    @simplo_orders = SimploOrder.where(order_status: %w[2 30 31]).order(order_id: :asc)
    @calendar = SimploOrder.calendar
  end

  def post_mail_control
    @post_data = PostDatum.all
  end

  def import_post_mail; end

  private

  def generate_csv(pending_order_items)
    CSV.generate(headers: true) do |csv|
      # Define your headers without 'Description'
      csv << ['SKU', 'Quantity', 'Total Value']

      # Group by SKU and sum quantities, calculate total value without including description
      grouped_items = pending_order_items.group_by(&:sku).map do |sku, items|
        total_quantity = items.sum(&:quantity)
        total_value = items.sum { |item| item.value.to_f * item.quantity }
        [sku, total_quantity, total_value]
      end

      # Sorting grouped items by total_quantity in descending order
      sorted_grouped_items = grouped_items.sort_by { |item| -item[1] }

      # Adding rows for each group of items
      sorted_grouped_items.each do |item|
        csv << item
      end
    end
  end

  def list_orders
    @orders = []
    (1..20).each do |i|
      @order_page = HTTParty.get("https://purchasestore.com.br/ws/wspedidos.json?page=#{i}",
                                 headers: { content: 'application/json',
                                            Appkey: '' })
      @order_page['result'].each do |order_page|
        @orders << order_page
      end
    end
  end

  def get_loja_name
    {
      204_219_105 => 'Shein',
      203_737_982 => 'Shopee',
      203_467_890 => 'Simplo 7',
      204_061_683 => 'Mercado Livre'
    }
  end

  def calculate_total_pieces_missing(sorted_items)
    return {} if sorted_items.nil? || sorted_items.empty?

    sorted_items.transform_values do |items|
      total_quantity = items.sum(&:quantity)
      sku_to_check = items.first.is_a?(Item) ? items.first.sku : items.first.first
      production_products = ProductionProduct.joins(:product).where(products: { sku: Product.where("sku LIKE ?", "#{sku_to_check}%").pluck(:sku) })
      total_produced = production_products.sum(:quantity)
      [total_quantity - total_produced, 0].max
    end
  end

  def calculate_sold_last_30_days
    start_date = 30.days.ago.beginning_of_day
    end_date = Time.current.end_of_day

    Item.joins(:bling_order_item)
        .where(account_id: current_tenant, bling_order_items: { date: start_date..end_date })
        .group(:sku)
        .sum(:quantity)
  end
end