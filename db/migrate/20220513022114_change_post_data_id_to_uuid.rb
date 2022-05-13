class ChangePostDataIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :post_data, :uuid, :uuid, default: "gen_random_uuid()", null: false

    rename_column :post_data, :id, :integer_id
    rename_column :post_data, :uuid, :id

    execute 'ALTER TABLE post_data drop constraint post_data_pkey'
    execute 'ALTER TABLE post_data ADD PRIMARY KEY (id)'
  end
end
