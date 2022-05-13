class EnableUuid < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'
  end
end
