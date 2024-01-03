# == Schema Information
#
# Table name: items
#
#  id                  :bigint           not null, primary key
#  description         :string
#  discount            :decimal(, )
#  ipi_tax             :decimal(, )
#  long_description    :string
#  quantity            :integer
#  sku                 :string
#  unity               :integer
#  value               :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :integer
#  bling_order_item_id :bigint
#  product_id          :bigint
#
require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:bling_order_item) }
  end

  describe 'db columns' do
    it { is_expected.to have_db_column(:sku) }
    it { is_expected.to have_db_column(:unity) }
    it { is_expected.to have_db_column(:value) }
    it { is_expected.to have_db_column(:quantity) }
  end
end
