
class ImportCustomerCSV 
  include CSVImporter
  
  model Customer

  # Maps the csv columns to attributes
  column :cellphone
  column :cpf
  column :email, required: true
  column :name
  column :phone
  column :account_id

  identifier :email 
end