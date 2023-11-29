# frozen_string_literal: true

module Services
  module Bling
    class FindOrders < ApplicationService
      attr_accessor :ids, :order_command, :tenant

      def initialize(order_command:, tenant:, ids:)
        @order_command = order_command
        @tenant = tenant 
        @ids = ids
      end

      def call
        case order_command
        when 'find_orders'
          find_orders
        else
          raise 'Not a order command'
        end
      end

      private

      def find_orders
        # Initialize hash for counting and a counter variable
        codigo_quantidade = {}
        counter = 0

        # Loop through each ID
        @ids.each do |id|
          # Call the service for each ID
          response = Services::Bling::FindOrder.call(id: id, order_command: 'find_order', tenant: @tenant)
          next unless response && response["data"] && response["data"]["itens"]

          # Process each item
          response["data"]["itens"].each do |item|
            order = BlingOrderItem.find_by(bling_order_id: id)
            
            order.update(items: item) if order.present?
            codigo = item["codigo"]
            quantidade = item["quantidade"]

            # Update counts
            codigo_quantidade[codigo] = codigo_quantidade.fetch(codigo, 0) + quantidade

            # Increment the counter
            counter += 1

            # Print the current item's codigo and quantidade along with the counter
            puts "Item #{counter} - Codigo: #{codigo}, Quantidade: #{quantidade}, Total for Codigo: #{codigo_quantidade[codigo]}"
          end
        end

        # File path for the CSV
        csv_file_path = 'codigo_quantidade.csv'

        # Generate CSV
        CSV.open(csv_file_path, 'w') do |csv|
          # Adding headers to the CSV file
          csv << ['Codigo', 'Total Quantidade']

          # Writing data to the CSV file
          codigo_quantidade.each do |codigo, quantidade|
            csv << [codigo, quantidade]
          end
        end

        puts "CSV file generated: #{csv_file_path}"

      end
    end
  end
end
