class SheinOrdersJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    begin
      spreadsheet = Roo::Spreadsheet.open(file_path)
      headers = spreadsheet.row(1)
      
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[headers, spreadsheet.row(i)].transpose]

        InsertSheinOrderJob.perform_later(row)
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
