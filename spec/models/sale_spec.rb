# frozen_string_literal: true

# == Schema Information
#
# Table name: sales
#
#  id                   :bigint           not null, primary key
#  disclosure           :boolean
#  discount             :float
#  exchange             :boolean          default(FALSE)
#  online               :boolean
#  order_code           :string
#  payment_type         :integer          default("Débito")
#  percentage           :float
#  store_sale           :integer          default("Sem_Loja")
#  total_exchange_value :float
#  value                :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :integer
#  customer_id          :bigint
#
# Indexes
#
#  index_sales_on_account_id   (account_id)
#  index_sales_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
require 'rails_helper'

RSpec.describe Sale, type: :model do
  it { is_expected.to have_many(:sale_products) }

  it { is_expected.to belong_to(:account) }

  context 'when create' do
    let(:sale) { create(:sale) }

    it 'is valid' do
      expect(sale).to be_valid
    end
  end
end
