require 'prawn'
require 'tempfile'

module Services
  module Product
    class GenerateQrCodePdf
      include Prawn::View

      QR_CODE_WIDTH = 200
      QR_CODE_HEIGHT = 250  # Total height including QR code and text
      HORIZONTAL_SPACING = 50
      VERTICAL_SPACING = 30

      def initialize(products, copies)
        @products = products
        @copies = copies
        
        # Calculate page margins to center content
        page_width = 595.28  # A4 width in points
        page_height = 841.89 # A4 height in points
        content_width = (QR_CODE_WIDTH * 2) + HORIZONTAL_SPACING
        content_height = (QR_CODE_HEIGHT * 2) + VERTICAL_SPACING
        
        left_margin = (page_width - content_width) / 2
        top_margin = (page_height - content_height) / 2

        @document = Prawn::Document.new(
          page_size: 'A4',
          margin: [top_margin, left_margin, top_margin, left_margin]
        )

        @current_x = 0
        @current_y = cursor
        @qr_codes_on_page = 0
        generate
      end

      private

      def generate
        @products.each do |product|
          @copies.times do
            # Start new page if we've already placed 4 QR codes
            if @qr_codes_on_page == 4
              break unless more_qr_codes?(product)
              start_new_page
              @current_x = 0
              @current_y = cursor
              @qr_codes_on_page = 0
            end

            # Get QR code image data
            qr_code_service = Services::Product::GenerateQrCode.new(product: product)
            qr_code_data = qr_code_service.call(for_download: true)
            
            # Create a temporary file for the QR code image
            temp_file = Tempfile.new(['qr_code', '.png'])
            temp_file.binmode
            temp_file.write(qr_code_data)
            temp_file.rewind

            # Add QR code image at current position
            image temp_file.path, at: [@current_x, @current_y], width: QR_CODE_WIDTH

            # Add SKU and name below QR code
            text_box product.sku,
                    at: [@current_x, @current_y - 210],
                    width: QR_CODE_WIDTH,
                    align: :center,
                    size: 12,
                    style: :bold

            text_box product.name,
                    at: [@current_x, @current_y - 230],
                    width: QR_CODE_WIDTH,
                    align: :center,
                    size: 10

            # Clean up temporary file
            temp_file.close
            temp_file.unlink

            # Update position and counter
            @qr_codes_on_page += 1
            if @qr_codes_on_page % 2 == 0
              @current_x = 0
              @current_y -= QR_CODE_HEIGHT + VERTICAL_SPACING
            else
              @current_x += QR_CODE_WIDTH + HORIZONTAL_SPACING
            end
          end
        end
      end

      def more_qr_codes?(current_product)
        # Check if there are more QR codes to generate after the current position
        current_index = @products.index(current_product)
        remaining_copies = @copies
        
        return false unless current_index

        if current_index < @products.length - 1
          # There are more products after this one
          return true
        elsif current_index == @products.length - 1
          # This is the last product, check if there are more copies to make
          remaining_copies > 1
        else
          false
        end
      end
    end
  end
end 