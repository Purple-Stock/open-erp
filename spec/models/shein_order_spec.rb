# == Schema Information
#
# Table name: shein_orders
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_shein_orders_on_account_id  (account_id)
#  data       :json

require 'rails_helper'

RSpec.describe SheinOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
