json.extract! finance_datum, :id, :date, :income, :expense, :fixed_amount, :created_at, :updated_at
json.url finance_datum_url(finance_datum, format: :json)
