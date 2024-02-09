# == Schema Information
#
# Table name: account_features
#
#  id         :bigint           not null, primary key
#  is_enabled :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  feature_id :integer          not null
#
require 'rails_helper'

RSpec.describe AccountFeature, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
