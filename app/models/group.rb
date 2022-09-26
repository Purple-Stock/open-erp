# == Schema Information
#
# Table name: groups
#
#  id          :bigint           not null, primary key
#  description :string
#  months      :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Group < ApplicationRecord
  has_many :group_products, inverse_of: :group, dependent: :destroy
  accepts_nested_attributes_for :group_products, reject_if: :all_blank, allow_destroy: true
end
