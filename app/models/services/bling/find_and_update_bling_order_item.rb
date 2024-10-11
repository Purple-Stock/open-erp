# frozen_string_literal: true

module Services
  module Bling
    class FindAndUpdateBlingOrderItem < ApplicationService
      attr_reader :identifier, :account_id

      def initialize(identifier:, account_id:)
        @identifier = identifier
        @account_id = account_id
      end

      def call
        bling_order_item = find_bling_order_item
        return { status: :not_found, message: 'Bling order item not found in local database' } unless bling_order_item

        order_data = find_order(bling_order_item.bling_order_id)
        
        if order_not_found?(order_data)
          delete_bling_order_item(bling_order_item)
        else
          update_bling_order_item(bling_order_item, order_data)
        end
      end

      private

      def find_bling_order_item
        BlingOrderItem.find_by(bling_order_id: @identifier) ||
          BlingOrderItem.find_by(marketplace_code_id: @identifier)
      end

      def find_order(bling_order_id)
        Services::Bling::FindOrder.call(
          id: bling_order_id,
          order_command: 'find_order',
          tenant: account_id
        )
      end

      def order_not_found?(order_data)
        order_data['error'].present? && order_data['error']['type'] == 'RESOURCE_NOT_FOUND'
      end

      def delete_bling_order_item(bling_order_item)
        bling_order_item.destroy
        { status: :deleted, message: 'Bling order item deleted as it was not found in Bling' }
      end

      def update_bling_order_item(bling_order_item, order_data)
        order_info = order_data.dig('data', 'data')
        if order_info.nil? || order_info['situacao'].nil?
          Rails.logger.error("Unexpected order_data structure: #{order_data.inspect}")
          return { status: :error, message: 'Unexpected order data structure from Bling API' }
        end

        new_status = map_bling_status_to_internal_status(order_info['situacao']['id'])
        bling_order_item.update(situation_id: new_status)
        { status: :updated, message: 'Bling order item status updated' }
      end

      def map_bling_status_to_internal_status(bling_status)
        # This mapping should be adjusted based on your specific status mappings
        case bling_status
        when 15 then BlingOrderItem::Status::IN_PROGRESS
        when 9 then BlingOrderItem::Status::FULFILLED
        when 101065 then BlingOrderItem::Status::CHECKED
        when 24 then BlingOrderItem::Status::VERIFIED
        when 94871 then BlingOrderItem::Status::PENDING
        when 95745 then BlingOrderItem::Status::PRINTED
        when 12 then BlingOrderItem::Status::CANCELED
        when 173631 then BlingOrderItem::Status::COLLECTED
        else BlingOrderItem::Status::ERROR
        end
      end
    end
  end
end