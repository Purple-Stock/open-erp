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
FactoryBot.define do
  factory :bling_datum do
    access_token { ENV['ACCESS_TOKEN'] }
    expires_in { 1 }
    token_type { "MyString" }
    scope { "MyText" }
    refresh_token { ENV['REFRESH_TOKEN'] }
  end
end
