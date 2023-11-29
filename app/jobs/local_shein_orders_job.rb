class LocalSheinOrdersJob < ApplicationJob
  queue_as :default

  def perform(file_path, current_tenant_id)
    begin
      SheinOrder.delete_all
      spreadsheet = Roo::Spreadsheet.open(file_path)
      headers = spreadsheet.row(1)

      orders = []
      
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[headers, spreadsheet.row(i)].transpose]

        orders << SheinOrder.new(data: row, current_tenant_id)
      end
      SheinOrder.import(orders)
    rescue => e
      # Log the error message
      Rails.logger.error "Error importing data: #{e.message}"
    ensure
      # Delete the file
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
