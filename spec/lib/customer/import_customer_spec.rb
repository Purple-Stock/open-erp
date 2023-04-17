# frozen_string_literal: true
require 'csv'
require 'customer/import_customer_csv'

describe 'ImportCustomerCSV' do
  let(:customer) { create(:customer) }
  
  it 'creates customers by importing a valid csv file' do 
    Tempfile.open(['customers.csv', '.csv']) do |temp|
      CSV.open(temp, 'wb', col_sep: ';', headers: true) do |csv|
        csv << %w[cellphone cpf email name phone account_id]
        csv << [customer.cellphone, customer.cpf, customer.email, 
                customer.name, customer.phone, customer.account_id]
      end

      import = ImportCustomerCSV.new(file: temp)
      import.run!
      expect(import.report.success?).to be true
    end
  end

  it 'Doesnt create customers by importing invalid csv file' do 
    Tempfile.open(['customers.csv', '.csv']) do |temp|
      CSV.open(temp, 'wb', col_sep: ';', headers: true) do |csv|
        csv << %w[cellphone cpf email name phone account_id]
        csv << [customer.cellphone]
      end

      import = ImportCustomerCSV.new(file: temp)
      import.run!
      expect(import.report.success?).to be false
    end
  end

  it 'Doesnt create customers without customers email' do
    Tempfile.open(['customers.csv', '.csv']) do |temp|
      CSV.open(temp, 'wb', col_sep: ';', headers: true) do |csv|
        csv << %w[cellphone cpf email name phone account_id]
        csv << [customer.cellphone, customer.cpf, customer.name, 
                customer.phone, customer.account_id]
      end

      import = ImportCustomerCSV.new(file: temp)
      import.run!
      expect(import.report.success?).to be false
    end
  end
end
