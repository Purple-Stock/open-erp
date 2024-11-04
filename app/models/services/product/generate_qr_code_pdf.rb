require 'prawn'
require 'tempfile'

module Services
  module Product
    class GenerateQrCodePdf
      include Prawn::View

      def initialize(products, copies)
        @products = products
        @copies = copies
        @document = Prawn::Document.new(
          page_size: 'A4',
          margin: [20, 20, 20, 20]
        )
        @current_x = 50
        @current_y = cursor
        generate
      end

      private

      def generate
        @products.each do |product|
          @copies.times do
            # Get QR code image data
            qr_code_service = Services::Product::GenerateQrCode.new(product: product)
            qr_code_data = qr_code_service.call(for_download: true)
            
            # Create a temporary file for the QR code image
            temp_file = Tempfile.new(['qr_code', '.png'])
            temp_file.binmode
            temp_file.write(qr_code_data)
            temp_file.rewind

            # Add QR code image at current position
            image temp_file.path, at: [@current_x, @current_y], width: 200

            # Add SKU and name below QR code
            text_box product.sku,
                    at: [@current_x, @current_y - 210],
                    width: 200,
                    align: :center,
                    size: 12,
                    style: :bold

            text_box product.name,
                    at: [@current_x, @current_y - 230],
                    width: 200,
                    align: :center,
                    size: 10

            # Clean up temporary file
            temp_file.close
            temp_file.unlink

            # Update position for next QR code
            if @current_x >= 300
              @current_x = 50
              @current_y -= 280
            else
              @current_x += 250
            end

            # Start new page if needed
            if @current_y < 250
              start_new_page
              @current_x = 50
              @current_y = cursor
            end
          end
        end
      end
    end
  end
end 