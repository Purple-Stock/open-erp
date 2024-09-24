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
        pdf.text "Data de entrada: #{@production.cut_date&.strftime("%d/%m/%Y")}"
        pdf.text "Data de conclusão: #{@production.production_products.maximum(:delivery_date)&.strftime("%d/%m/%Y")}"
        pdf.text "Data de pagamento: #{@production.payment_date&.strftime("%d/%m/%Y")}"
        pdf.move_down 20
      end
      
      def generate_products_table(pdf)
        pdf.text "Peças Entregues", size: 14, style: :bold
        pdf.move_down 10
      
        data = [["Produto", "Quantidade", "Preço Un.", "Sujo", "Erro", "Descarte", "Devolvido", "Desconto", "Total"]]
      
        total_all_rows = 0
        total_discount = 0
      
        @production.production_products.each do |pp|
          unit_price = pp.unit_price || 0
          total_price = pp.total_price || 0
          adjusted_quantity = pp.pieces_delivered - (pp.dirty + pp.error + pp.discard)
          discount = unit_price * (pp.dirty + pp.error + pp.discard)
          returned_discount = pp.returned ? total_price : 0
          total_discount_row = discount + returned_discount
          adjusted_price = unit_price * adjusted_quantity - total_discount_row
      
          total_all_rows += total_price
          total_discount += total_discount_row
      
          data << [
            pp.product.name,
            pp.pieces_delivered,
            number_to_currency(unit_price),
            pp.dirty,
            pp.error,
            pp.discard,
            pp.returned ? 'Sim' : 'Não',
            number_to_currency(total_discount_row),
            number_to_currency(adjusted_price)
          ]
        end
      
        # Add a row for totals
        data << [
          "Total",
          @production.production_products.sum(:pieces_delivered),
          "",
          @production.production_products.sum(:dirty),
          @production.production_products.sum(:error),
          @production.production_products.sum(:discard),
          @production.production_products.where(returned: true).count,
          number_to_currency(total_discount),
          number_to_currency(total_all_rows - total_discount)
        ]
      
        column_widths = [120, 60, 60, 40, 40, 40, 60, 60, 80]
      
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
                             style: (row_index == 0 || row_index == data.length - 1 ? :bold : :normal),
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
        total_discount = @production.production_products.sum do |pp|
          discount = (pp.unit_price || 0) * (pp.dirty + pp.error + pp.discard)
          discount += (pp.total_price || 0) if pp.returned
          discount
        end
      
        total_price = @production.production_products.sum { |pp| pp.total_price || 0 }
        total_to_pay = total_price - total_discount
      
        pdf.text "Total do corte: #{number_to_currency(total_price)}", style: :bold, align: :right
        pdf.move_down 10
        pdf.text "Total desconto: #{number_to_currency(total_discount)}", style: :bold, align: :right
        pdf.move_down 10
        pdf.text "Total a pagar: #{number_to_currency(total_to_pay)}", style: :bold, align: :right
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