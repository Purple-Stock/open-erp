# == Schema Information
#
# Table name: features
#
#  id          :bigint           not null, primary key
#  feature_key :integer          default(0), not null
#  is_enabled  :boolean          default(FALSE), not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Feature, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
