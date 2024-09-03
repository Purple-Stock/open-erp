# == Schema Information
#
# Table name: productions
#
#  id                     :bigint           not null, primary key
#  confirmed              :boolean
#  consider               :boolean          default(FALSE)
#  cut_date               :datetime
#  deliver_date           :datetime
#  delivery_date          :date
#  expected_delivery_date :date
#  observation            :text
#  paid                   :boolean
#  pieces_delivered       :integer
#  pieces_missing         :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  tailor_id              :bigint
#
# Indexes
#
#  index_productions_on_account_id              (account_id)
#  index_productions_on_cut_date                (cut_date)
#  index_productions_on_delivery_date           (delivery_date)
#  index_productions_on_expected_delivery_date  (expected_delivery_date)
#  index_productions_on_tailor_id               (tailor_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (tailor_id => tailors.id)
#
require 'rails_helper'

RSpec.describe Production, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
