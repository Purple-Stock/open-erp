# == Schema Information
#
# Table name: warehouses
#
#  id             :bigint           not null, primary key
#  description    :string           not null
#  ignore_balance :boolean          default(FALSE), not null
#  is_default     :boolean          default(FALSE), not null
#  status         :integer          default("active"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  bling_id       :string           not null
#
# Indexes
#
#  index_warehouses_on_bling_id_and_account_id  (bling_id,account_id) UNIQUE
#  index_warehouses_on_status                   (status)
#

class Warehouse < ApplicationRecord
    acts_as_tenant :account
  
    validates :bling_id, presence: true, uniqueness: { scope: :account_id }
    validates :description, presence: true
  
    enum status: { inactive: 0, active: 1 }
  
    scope :active, -> { where(status: :active) }
    scope :inactive, -> { where(status: :inactive) }
  
    def self.sync_from_bling(bling_data, account_id)
      bling_data.each do |warehouse_data|
        warehouse = find_or_initialize_by(bling_id: warehouse_data['id'], account_id: account_id)
        warehouse.assign_attributes(
          description: warehouse_data['descricao'],
          status: warehouse_data['situacao'] == 1 ? 1 : 0,
          is_default: warehouse_data['padrao'],
          ignore_balance: warehouse_data['desconsiderarSaldo']
        )
        warehouse.save!
      end
    end
  end
