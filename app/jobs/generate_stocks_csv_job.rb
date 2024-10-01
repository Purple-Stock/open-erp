class GenerateStocksCsvJob < ApplicationJob
  queue_as :default

  def perform(tenant_id, email)
    stocks_export = Stock.where(account_id: tenant_id)
    csv_data = stocks_export.to_csv
    StockMailer.send_csv(email, csv_data).deliver_now
  end
end