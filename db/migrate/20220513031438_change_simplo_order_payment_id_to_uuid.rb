class ChangeSimploOrderPaymentIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :simplo_order_payments, :uuid, :uuid, default: "gen_random_uuid()", null: false

    rename_column :simplo_order_payments, :id, :integer_id
    rename_column :simplo_order_payments, :uuid, :id

    execute 'ALTER TABLE simplo_order_payments drop constraint simplo_order_payments_pkey'
    execute 'ALTER TABLE simplo_order_payments ADD PRIMARY KEY (id)'
  end
end
