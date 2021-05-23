class CreatePostData < ActiveRecord::Migration[6.0]
  def change
    create_table :post_data do |t|
      t.string :client_name
      t.string :cep
      t.string :state
      t.string :post_code
      t.string :post_type
      t.float :value
      t.datetime :send_date

      t.timestamps
    end
  end
end
