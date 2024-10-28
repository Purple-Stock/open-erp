module Services
  module Product
    class GenerateQrCode
      def initialize(product:)
        @product = product
      end

      def call
        qr_data = { id: @product.id, account_id: @product.account_id }.to_json
        qr_code = RQRCode::QRCode.new(qr_data)
        qr_code.as_png(size: 50).to_data_url
      end
    end
  end
end 