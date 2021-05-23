class CreateSimploOrderPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :simplo_order_payments do |t|
      t.string :order_id
      t.string :client_name
      t.string :integrador
      t.string :pagamento_forma
      t.string :codigo_transacao
      t.string :parcelas
      t.string :total
      t.string :data_pedido
      t.string :order_status

      t.timestamps
    end
  end
end
