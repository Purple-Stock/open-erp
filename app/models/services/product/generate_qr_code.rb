# frozen_string_literal: true

module Services
  module Product
    class GenerateQrCode < ApplicationService
      attr_reader :product, :width, :height

      def initialize(product, width: 300, height: 300)
        @product = product
        @width = width
        @height = height
      end

      def call
        object = { id: @product.id, custom_id: @product.custom_id, name: @product.name }
        RQRCode::QRCode.new(object.to_json).to_img.resize(@width, @height).to_data_url
      end
    end
  end
end
