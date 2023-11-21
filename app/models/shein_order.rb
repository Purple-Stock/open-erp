# == Schema Information
#
# Table name: shein_orders
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'zip'

class SheinOrder < ApplicationRecord

  def self.import_from_file(file, current_tenant_id)
    # Define a path for the directory to save uploaded files
    dir_path = Rails.root.join('tmp', 'uploads')
    # Ensure the directory exists
    FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)

    # Define a path to save the uploaded file temporarily
    temp_path = File.join(dir_path, file.original_filename)

    # Save the uploaded file
    File.open(temp_path, 'wb') do |f|
      f.write(file.read)
    end

    # Check if the file is a ZIP archive
    if File.extname(temp_path) == '.zip'
      # Define a directory to extract the ZIP contents
      extract_path = Rails.root.join('tmp', 'sheets', SecureRandom.uuid)
      # Ensure the extraction directory exists
      FileUtils.mkdir_p(extract_path) unless Dir.exist?(extract_path)

      begin
        # Unzip the file
        Zip::File.open(temp_path) do |zip_file|
          zip_file.each do |entry|
            # Define a path for the extracted file
            file_path = File.join(extract_path, entry.name)
            # Extract the file
            entry.extract(file_path)
            # Enqueue the job for each extracted file
            SheinOrdersJob.perform_later(file_path, current_tenant_id)
          end
        end
      rescue Zip::Error => e
        Rails.logger.error "Failed to unzip file: #{e.message}"
        # Handle the error appropriately
      end
    else
      # Process non-ZIP files
      SheinOrdersJob.perform_later(temp_path.to_s, current_tenant_id)
    end

    # Optionally, delete the original uploaded file if no longer needed
    File.delete(temp_path) if File.exist?(temp_path)
  end
end
