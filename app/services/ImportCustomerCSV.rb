class ImportCustomerCSV
	include CSVImporter

	model Customer

	# Maps the csv columns to attributes
	column :cellphone
	column :cpf
	column :email
	column :name
	column :phone
	column :account_id  
end