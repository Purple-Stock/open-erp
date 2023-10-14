# == Schema Information
#
# Table name: shein_orders
#
#  id         :bigint           not null, primary key
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe SheinOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
