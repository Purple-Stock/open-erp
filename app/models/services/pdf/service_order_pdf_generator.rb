require 'prawn'

module Services
  module Pdf
    class ServiceOrderPdfGenerator
      include ActionView::Helpers::NumberHelper

      def initialize(production)
        @production = production
      end

      def generate
        Prawn::Document.new do |pdf|
          setup_font(pdf)
          generate_header(pdf)
          generate_client_details(pdf)
          generate_products_table(pdf)
          generate_totals(pdf)
          generate_observations(pdf)
          generate_signature(pdf)
        end
      end

      private

      def setup_font(pdf)
        pdf.font_families.update("DejaVu" => {
          normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
          bold: "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf"
        })
        pdf.font "DejaVu"
      end

      def generate_header(pdf)
        pdf.text "Ordem de serviço N° #{@production.service_order_number}", size: 16, style: :bold
        pdf.move_down 20
      end

      def generate_client_details(pdf)
        pdf.text "Cliente: #{@production.tailor.name}", style: :bold
        pdf.text "Endereço: Endereço do cliente" # Replace with actual address when available
        pdf.text "Número da OS: #{@production.service_order_number}"
        pdf.text "Data de entrada: #{@production.cut_date&.strftime("%d/%m/%Y")}"
        pdf.text "Data prevista: #{@production.expected_delivery_date&.strftime("%d/%m/%Y")}"
        pdf.text "Data de conclusão: "
        pdf.move_down 20
      end

      def generate_products_table(pdf)
        pdf.text "Peças", size: 14, style: :bold
        pdf.move_down 10

        @production.production_products.each do |pp|
          pdf.text "Produto: #{pp.product.name}"
          pdf.text "Código: #{pp.product.sku}"
          pdf.text "Quantidade: #{pp.quantity}"
          pdf.text "Preço un.: #{number_to_currency(pp.unit_price)}"
          pdf.text "Valor total: #{number_to_currency(pp.total_price)}"
          pdf.move_down 10
        end

        pdf.move_down 20
      end

      def generate_totals(pdf)
        pdf.text "Total serviços: #{number_to_currency(0)}", align: :right
        pdf.text "Total peças: #{number_to_currency(@production.total_price)}", align: :right
        pdf.text "Total da ordem de serviço: #{number_to_currency(@production.total_price)}", style: :bold, align: :right
        pdf.move_down 30
      end

      def generate_observations(pdf)
        if @production.observation.present?
          pdf.text "Observações do Serviço", style: :bold
          pdf.text @production.observation
          pdf.move_down 20
        end
      end

      def generate_signature(pdf)
        pdf.text "Concordo com os termos descritos acima."
        pdf.move_down 10
        pdf.text "Data _____/_____/_____"
        pdf.move_down 20
        pdf.stroke_horizontal_rule
        pdf.move_down 5
        pdf.text "Assinatura do responsável"
      end
    end
  end
end
