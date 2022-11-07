# frozen_string_literal: true

class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :cpf_cnpj, :string
    add_column :users, :phone, :string
  end
end
