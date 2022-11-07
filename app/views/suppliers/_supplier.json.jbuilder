# frozen_string_literal: true

json.extract! supplier, :id, :name, :cnpj, :email, :cellphone, :phone, :address, :city, :state, :landmark, :note,
              :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
