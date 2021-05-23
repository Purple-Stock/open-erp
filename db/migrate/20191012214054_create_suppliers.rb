class CreateSuppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :cnpj
      t.string :email
      t.string :cellphone
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :landmark
      t.string :note

      t.timestamps
    end
  end
end
