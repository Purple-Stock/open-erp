# == Schema Information
#
# Table name: bling_data
#
#  id            :bigint           not null, primary key
#  access_token  :string
#  expires_at    :datetime
#  expires_in    :integer
#  refresh_token :string
#  scope         :text
#  token_type    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :integer
#
# Indexes
#
#  index_bling_data_on_account_id  (account_id)
#
class BlingDatum < ApplicationRecord
end
