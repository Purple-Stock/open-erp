class Localization < ApplicationRecord
  belongs_to :account
  belongs_to :bling_order_item, optional: false
end