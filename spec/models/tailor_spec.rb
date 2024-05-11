# == Schema Information
#
# Table name: tailors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_tailors_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe Tailor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
