class InsertSheinOrderJob < ApplicationJob
  queue_as :default

  def perform(row, current_tenant_id)
    begin
      shein_order = SheinOrder.where("data ->> 'Número do pedido' = ?", row["Número do pedido"].to_s).first_or_initialize
      
      # Update and save the order with all columns
      shein_order.update(data: row, account_id: current_tenant_id)
      shein_order.save!
    end
    rescue => e
      # Log the error message
      Rails.logger.error "Error updating order: #{e.message}"
  end
end
