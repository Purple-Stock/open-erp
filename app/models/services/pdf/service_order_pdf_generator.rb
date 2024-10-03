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
        pdf.text "Data de entrada do corte: #{@production.cut_date&.strftime("%d/%m/%Y")}"
        pdf.text "Data prevista para entrega: #{@production.expected_delivery_date&.strftime("%d/%m/%Y")}"
        pdf.text "Data prevista para pagamento: #{@production.payment_date&.strftime("%d/%m/%Y")}"
        
        pdf.move_down 10
        pdf.text "Cláusula de Pagamento:", style: :bold
        pdf.text "Em caso de atraso na entrega, a data de pagamento será automaticamente adiada pelo mesmo período do atraso."
        
        pdf.move_down 20
      end
      
      def generate_products_table(pdf)
        pdf.text "Peças", size: 14, style: :bold
        pdf.move_down 10
      
        data = [["Produto", "Código", "Quantidade", "Preço un.", "Valor total"]]
      
        @production.production_products.each do |pp|
          data << [
            pp.product.name,
            pp.product.sku,
            pp.quantity,
            number_to_currency(pp.unit_price),
            number_to_currency(pp.total_price)
          ]
        end
      
        column_widths = [200, 100, 60, 60, 80]
        
        # Calculate row heights
        row_heights = data.map do |row|
          row.map.with_index do |cell, i|
            pdf.height_of(cell.to_s, width: column_widths[i], size: 10) + 10 # Add some padding
          end.max
        end
      
        pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: row_heights.sum + 1) do
          y_position = pdf.bounds.top
      
          data.each_with_index do |row, row_index|
            row_height = row_heights[row_index]
            
            # Fill header row
            if row_index == 0
              pdf.fill_color "DDDDDD"
              pdf.fill_rectangle [0, y_position], pdf.bounds.width, row_height
              pdf.fill_color "000000"
            end
      
            # Draw horizontal line
            pdf.stroke_horizontal_line 0, pdf.bounds.width, at: y_position
      
            # Draw cell contents
            x_position = 0
            row.each_with_index do |cell, col_index|
              width = column_widths[col_index]
              pdf.bounding_box([x_position, y_position], width: width, height: row_height) do
                pdf.text_box cell.to_s, 
                             size: 10, 
                             align: :center,
                             valign: :center,
                             overflow: :shrink_to_fit,
                             style: (row_index == 0 ? :bold : :normal),
                             at: [0, pdf.cursor],
                             width: width,
                             height: row_height
              end
              x_position += width
            end
      
            y_position -= row_height
          end
      
          # Draw vertical lines
          column_widths.reduce(0) do |x_position, width|
            pdf.stroke_vertical_line pdf.bounds.top, pdf.bounds.bottom, at: x_position
            x_position + width
          end
          pdf.stroke_vertical_line pdf.bounds.top, pdf.bounds.bottom, at: pdf.bounds.width
      
          # Draw bottom line
          pdf.stroke_horizontal_line 0, pdf.bounds.width, at: pdf.bounds.bottom
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