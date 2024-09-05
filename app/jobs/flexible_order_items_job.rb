# frozen_string_literal: true

class FlexibleOrderItemsJob < BlingOrderItemCreatorBaseJob
    queue_as :default
  
    attr_accessor :account_id, :statuses, :start_date, :end_date
  
    def perform(account_id, statuses, options = {})
      @account_id = account_id
      @statuses = Array(statuses)
      set_date_range(options)
  
      options.merge!(date_range_options)
  
      all_orders = []
  
      @statuses.each do |status|
        orders = fetch_orders(status, options)
        all_orders.concat(orders)
      end
  
      create_orders(all_orders)
    end
  
    private
  
    def set_date_range(options)
      @start_date = options.delete(:start_date)
      @end_date = options.delete(:end_date)
    end
  
    def fetch_orders(status, options)
      response = Services::Bling::Order.call(
        order_command: 'find_orders',
        tenant: @account_id,
        situation: status,
        options: options
      )
      response['data']
    end
  
    def date_range_options
      return {} unless date_range_present?
  
      {
        dataEmissao: {
          inicial: @start_date.to_date.iso8601,
          final: @end_date.to_date.iso8601
        }
      }
    end
  
    def date_range_present?
      @start_date.present? && @end_date.present?
    end
  end