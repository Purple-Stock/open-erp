class SheinOrdersJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    begin
      spreadsheet = Roo::Spreadsheet.open(file_path)
      headers = spreadsheet.row(1)
      
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[headers, spreadsheet.row(i)].transpose]
        
        # Find an existing order by number or initialize a new one
        # Assuming "Número do pedido" is a unique identifier for orders
        shein_order = SheinOrder.where("data ->> 'Número do pedido' = ?", row["Número do pedido"].to_s).first_or_initialize
        
        # Update and save the order with all columns
        shein_order.update(data: row)
        shein_order.save!
      end
    rescue => e
      # Log the error message
      Rails.logger.error "Error importing data: #{e.message}"
    ensure
      # Delete the file
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
