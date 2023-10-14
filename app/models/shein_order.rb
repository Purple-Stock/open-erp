# == Schema Information
#
# Table name: shein_orders
#
#  id         :bigint           not null, primary key
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# app/models/shein_order.rb

class SheinOrder < ApplicationRecord
  def self.import_from_file(file)
    # Generate a filename using a UUID to avoid conflicts
    filename = SecureRandom.uuid
    # Define a path to save the file
    path = Rails.root.join('tmp', 'sheets', file.original_filename)
    
    # Ensure directory exists
    FileUtils.mkdir_p(File.dirname(path)) unless Dir.exist?(File.dirname(path))
    
    # Save the uploaded file to the specified path
    File.open(path, 'wb') do |f|
      f.write(file.read)
    end
    
    # Enqueue the job with the path to the saved file
    SheinOrdersJob.perform_later(path.to_s)
  end
end
