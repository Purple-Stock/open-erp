# == Schema Information
#
# Table name: localizations
#
#  id                  :bigint           not null, primary key
#  address             :string
#  city                :string
#  complement          :string
#  country_name        :string
#  name                :string
#  neighborhood        :string
#  number              :string
#  state               :string
#  zip_code            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :integer
#  bling_order_item_id :bigint
#
class Localization < ApplicationRecord
  belongs_to :account
  belongs_to :bling_order_item, optional: false
end
