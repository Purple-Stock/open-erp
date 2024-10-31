# frozen_string_literal: true

require 'rqrcode'

module Services
  module Product
    class GenerateQrCode < ApplicationService
      attr_reader :product, :width, :height

      def initialize(product:, width: 300, height: 300)
        @product = product
        @width = width
        @height = height
      end

      def call(for_download: false)
        # Create QR code with product data
        object = {
          id: @product.id,
          account_id: @product.account_id,
          sku: @product.decorate.sku
        }
        
        qr_code = RQRCode::QRCode.new(object.to_json)
        
        # Generate PNG data
        png = qr_code.as_png(
          bit_depth: 1,
          border_modules: 4,
          color_mode: ChunkyPNG::COLOR_GRAYSCALE,
          color: 'black',
          file: nil,
          fill: 'white',
          module_px_size: 6,
          size: @width
        )

        if for_download
          png.to_s
        else
          "data:image/png;base64,#{Base64.strict_encode64(png.to_s)}"
        end
      end
    end
  end
end