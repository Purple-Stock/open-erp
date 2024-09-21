require 'prawn'

module Services
  module Pdf
    class PaymentOrderPdfGenerator
      include ActionView::Helpers::NumberHelper

      def initialize(production)
        @production = production
      end

      def generate
        Prawn::Document.new do |pdf|
          setup_font(pdf)
          generate_header(pdf)
          generate_tailor_details(pdf)
          generate_products_table(pdf)
          generate_totals(pdf)
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
        pdf.text "Ordem de Pagamento N° #{@production.service_order_number}", size: 16, style: :bold
        pdf.move_down 20
      end

      def generate_tailor_details(pdf)
        pdf.text "Costureiro: #{@production.tailor.name}", style: :bold
        pdf.text "Número da OS: #{@production.service_order_number}"
        pdf.text "Data de entrada: #{@production.cut_date&.strftime("%d/%m/%Y")}"
        pdf.text "Data de conclusão: #{@production.production_products.maximum(:delivery_date)&.strftime("%d/%m/%Y")}"
        pdf.move_down 20
      end

      def generate_products_table(pdf)
        pdf.text "Peças Entregues", size: 14, style: :bold
        pdf.move_down 10
      
        data = [["Produto", "Quantidade", "Preço Un.", "Sujo", "Erro", "Descarte", "Total"]]
      
        @production.production_products.each do |pp|
          adjusted_quantity = pp.pieces_delivered - (pp.dirty + pp.error + pp.discard)
          adjusted_price = pp.unit_price * adjusted_quantity
          
          data << [
            pp.product.name,
            pp.pieces_delivered,
            number_to_currency(pp.unit_price),
            pp.dirty,
            pp.error,
            pp.discard,
            number_to_currency(adjusted_price)
          ]
        end
      
        table_width = pdf.bounds.width
        columns = data.first.length
        column_widths = [0.4, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1].map { |w| w * table_width }
        row_height = 30
      
        data.each_with_index do |row, row_index|
          y_position = pdf.cursor
      
          # Draw horizontal line
          pdf.stroke_horizontal_line(0, table_width, at: y_position)
      
          row.each_with_index do |cell, col_index|
            x_position = column_widths.take(col_index).sum
            cell_width = column_widths[col_index]
      
            # Draw vertical line
            pdf.stroke_vertical_line(y_position, y_position - row_height, at: x_position)
      
            # Add cell content
            pdf.bounding_box([x_position + 2, y_position - 2], width: cell_width - 4, height: row_height - 4) do
              pdf.text cell.to_s, size: 10, align: (col_index == 0 ? :left : :center), valign: :center
            end
          end
      
          # Draw last vertical line
          pdf.stroke_vertical_line(y_position, y_position - row_height, at: table_width)
      
          pdf.move_down row_height
        end
      
        # Draw bottom line of the table
        pdf.stroke_horizontal_line(0, table_width)
      
        pdf.move_down 20
      end

      def generate_totals(pdf)
        total_price = @production.production_products.sum do |pp|
          adjusted_quantity = pp.pieces_delivered - (pp.dirty + pp.error + pp.discard)
          pp.unit_price * adjusted_quantity
        end

        pdf.text "Total a pagar: #{number_to_currency(total_price)}", style: :bold, align: :right
        pdf.move_down 30
      end

      def generate_signature(pdf)
        pdf.text "Assinatura do Costureiro: ________________________________"
        pdf.move_down 20
        pdf.text "Data: _____/_____/_____"
      end
    end
  end
end